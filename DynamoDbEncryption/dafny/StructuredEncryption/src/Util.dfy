// Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

include "../Model/AwsCryptographyDbEncryptionSdkStructuredEncryptionTypes.dfy"

module StructuredEncryptionUtil {
  import opened AwsCryptographyDbEncryptionSdkStructuredEncryptionTypes
  import opened Wrappers
  import opened StandardLibrary
  import opened StandardLibrary.UInt
  import UTF8
  import CMP = AwsCryptographyMaterialProvidersTypes
  import CSE = AwsCryptographyDbEncryptionSdkStructuredEncryptionTypes
  import AlgorithmSuites

  // all attributes with this prefix reserved for the implementation
  const ReservedPrefix := "aws_dbe_"

  const HeaderField := ReservedPrefix + "head"
  const FooterField := ReservedPrefix + "foot"
  const ReservedCryptoContextPrefixString := "aws-crypto-"
  const ReservedCryptoContextPrefixUTF8 := UTF8.EncodeAscii("aws-crypto-")

  //= specification/structured-encryption/encrypt-structure.md#header-field
  //= type=implication
  //# The Header Field name MUST be `aws_dbe_head`

  //= specification/structured-encryption/encrypt-structure.md#footer-field
  //= type=implication
  //# The Footer Field name MUST be `aws_dbe_foot`
  lemma CheckNames()
    ensures HeaderField == "aws_dbe_head"
    ensures FooterField == "aws_dbe_foot"
  {}

  const TYPEID_LEN := 2
  const BYTES_TYPE_ID : seq<uint8> := [0xFF, 0xFF]
  lemma BYTES_TYPE_ID_OK()
    ensures |BYTES_TYPE_ID| == TYPEID_LEN
  {}

  // Currently, only one set of sizes are supported
  const KeySize := 32 // 256 bits, for 256-bit AES keys
  const NonceSize := 12 // 96 bits, per AES-GCM nonces
  const AuthTagSize := 16
  const MSGID_LEN := 32
  const DbeAlgorithmFamily : uint8 := 0x67

  lemma ValidSuiteSizes(alg : CMP.AlgorithmSuiteInfo)
    requires ValidSuite(alg)
    ensures AlgorithmSuites.GetEncryptKeyLength(alg) as int == KeySize
    ensures alg.encrypt.AES_GCM.keyLength as int == KeySize
    ensures alg.encrypt.AES_GCM.tagLength as int == AuthTagSize
    ensures alg.encrypt.AES_GCM.ivLength as int == NonceSize
  {}

  const DoNotSign :=
    CSE.AuthenticateSchema(content := CSE.AuthenticateSchemaContent.Action(CSE.AuthenticateAction.DO_NOT_SIGN), attributes := None)
  const DoSign :=
    CSE.AuthenticateSchema(content := CSE.AuthenticateSchemaContent.Action(CSE.AuthenticateAction.SIGN), attributes := None)
  const EncryptAndSign :=
    CSE.CryptoSchema(content := CSE.CryptoSchemaContent.Action(CSE.CryptoAction.ENCRYPT_AND_SIGN), attributes := None);
  const SignOnly :=
    CSE.CryptoSchema(content := CSE.CryptoSchemaContent.Action(CSE.CryptoAction.SIGN_ONLY), attributes := None);
  const DoNothing :=
    CSE.CryptoSchema(content := CSE.CryptoSchemaContent.Action(CSE.CryptoAction.DO_NOTHING), attributes := None);

  type Key = x : seq<uint8> | |x| == KeySize witness *
  type Nonce = x : seq<uint8> | |x| == NonceSize witness *
  type AuthTag = x : seq<uint8> | |x| == AuthTagSize witness *
  type MessageID = x: Bytes | |x| == MSGID_LEN witness *

  type Bytes = seq<uint8>
  type CanonicalPath = seq<uint8>
  type GoodString = x : string | ValidString(x)

  type StructuredDataTerminalType = x : StructuredData | x.content.Terminal? witness *
  type CryptoSchemaActionType = x : CryptoSchema | x.content.Action? witness *
  type AuthSchemaActionType = x : AuthenticateSchema | x.content.Action? witness *

  type StructuredDataXXX = x : map<GoodString, StructuredData> | forall k <- x :: x[k].content.Terminal?
  type StructuredDataPlain = map<GoodString, StructuredDataTerminalType>
  type StructuredDataCanon = map<CanonicalPath, StructuredDataTerminalType>
  type CryptoSchemaPlain = map<GoodString, CryptoSchemaActionType>
  type CryptoSchemaCanon = map<CanonicalPath, CryptoSchemaActionType>
  type AuthSchemaPlain = map<GoodString, AuthSchemaActionType>
  type AuthSchemaCanon = map<CanonicalPath, AuthSchemaActionType>
  type CanonMap = map<CanonicalPath, GoodString>

  // Within the context of the StructuredEncryptionClient, certain things must be true of any Algorithm Suite
  predicate method ValidSuite(alg : CMP.AlgorithmSuiteInfo)
  {
    alg.id.DBE? && AlgorithmSuites.DBEAlgorithmSuite?(alg)
  }

  predicate method ValidString(x : string)
  {
    && |x| <  UINT64_LIMIT
    && UTF8.Encode(x).Success?
  }

  // string to Error
  function method E(s : string) : Error {
    StructuredEncryptionException(message := s)
  }

  // sequences are equal if zero is returned
  // Some care should be taken to ensure that target languages don't over optimize this.
  function method {:tailrecursion} ConstantTimeCompare(a : Bytes, b : Bytes, acc : bv8 := 0) : bv8
    requires |a| == |b|
  {
    if |a| == 0 then
      acc
    else
      var x := ((a[0] as bv8) ^ (b[0] as bv8));
      ConstantTimeCompare(a[1..], b[1..], x | acc)
  }

  predicate method ConstantTimeEquals(a : Bytes, b : Bytes)
    requires |a| == |b|
  {
    ConstantTimeCompare(a, b) == 0
  }

  // Is the CryptoSchemaMap flat, i.e., does it contain only Actions?
  function method CryptoSchemaMapIsFlat(data : CryptoSchemaMap) : (ret : bool)
    ensures ret ==> (forall v <- data.Values :: v.content.Action?)
  {
    forall k <- data :: data[k].content.Action?
  }

  // Schema must contain only Actions
  function method AuthSchemaIsFlat(data : AuthenticateSchemaMap) : (ret : bool)
    ensures ret ==> (forall v <- data.Values :: v.content.Action?)
  {
    forall k <- data :: data[k].content.Action?
  }

  // Map must contain only Terminals
  function method DataMapIsFlat(data : StructuredDataMap) : (ret : bool)
    ensures ret ==> (forall v <- data.Values :: v.content.Terminal?)
  {
    forall k <- data :: data[k].content.Terminal?
  }

  // attribute is "authorized", a.k.a. included in the signature
  predicate method IsAuthAttr(x : CryptoAction)
  {
    x.ENCRYPT_AND_SIGN? || x.SIGN_ONLY?
  }

  // wrap a value in a StructuredData
  function method ValueToData(value : Bytes, typeId : Bytes)
    : StructuredData
    requires IsValid_TerminalTypeId(typeId)
  {
    StructuredData(
      content := StructuredDataContent.Terminal(
        Terminal := StructuredDataTerminal(
          typeId := typeId,
          value := value
        )
      ),
      attributes := None
    )
  }

  // extract a value from a StructuredData
  function method GetValue(data : StructuredData) : Bytes
    requires data.content.Terminal?
  {
    data.content.Terminal.value
  }

  predicate method ByteLess(x : uint8, y : uint8)
  {
    x < y
  }

  predicate method CharLess(x : char, y : char)
  {
    x < y
  }
}

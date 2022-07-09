// Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
// Do not modify this file. This file is machine generated, and any changes to it will be overwritten.
include "../../StandardLibrary/StandardLibrary.dfy"
 include "../../Util/UTF8.dfy"
 module {:extern "Dafny.Aws.Cryptography.StructuredEncryption.Types" } AwsCryptographyStructuredEncryptionTypes
 {
 import opened Wrappers
 import opened StandardLibrary.UInt
 import opened UTF8
 // Generic helpers for verification of mock/unit tests.
 datatype DafnyCallEvent<I, O> = DafnyCallEvent(input: I, output: O)
 function Last<T>(s: seq<T>): T requires |s| > 0 { s[|s|-1] }
 
 // Begin Generated Types
 
 datatype CryptoAction =
	| ENCRYPT_AND_SIGN
	| SIGN_ONLY
	| IGNORE
 datatype CryptoSchema = | CryptoSchema (
 nameonly content: CryptoSchemaContent ,
 nameonly attributes: Option<CryptoSchemaAttributes>
 )
 type CryptoSchemaAttributes = map<string, CryptoAction>
 datatype CryptoSchemaContent =
 | action(CryptoAction: CryptoAction)
 | mapSchema(CryptoSchemaMap: CryptoSchemaMap)
 | listSchema(CryptoSchemaList: CryptoSchemaList)
 type CryptoSchemaList = seq<CryptoSchema>
 type CryptoSchemaMap = map<string, CryptoSchema>
 datatype DecryptStructureInput = | DecryptStructureInput (
 nameonly ciphertextStructure: StructuredData ,
 nameonly cryptoSchema: CryptoSchema
 )
 datatype DecryptStructureOutput = | DecryptStructureOutput (
 nameonly plaintextStructure: StructuredData
 )
 datatype EncryptStructureInput = | EncryptStructureInput (
 nameonly plaintextStructure: StructuredData ,
 nameonly cryptoSchema: CryptoSchema
 )
 datatype EncryptStructureOutput = | EncryptStructureOutput (
 nameonly ciphertextStructure: StructuredData
 )
 datatype StructuredData = | StructuredData (
 nameonly content: StructuredDataContent ,
 nameonly attributes: Option<StructuredDataAttributes>
 )
 type StructuredDataAttributes = map<string, Terminal>
 datatype StructuredDataContent =
 | terminal(Terminal: Terminal)
 | dataList(StructuredDataList: StructuredDataList)
 | dataMap(StructuredDataMap: StructuredDataMap)
 type StructuredDataList = seq<StructuredData>
 type StructuredDataMap = map<string, StructuredData>
 trait {:termination false} IStructuredEncryptionClient
 {
 ghost var EncryptStructureHistoricalCallEvents: seq<DafnyCallEvent<EncryptStructureInput, Result<EncryptStructureOutput, Error>>>
 predicate EncryptStructureEnsuresPublicly(input: EncryptStructureInput, output: Result<EncryptStructureOutput, Error>)
 // The public method to be called by library consumers
 method EncryptStructure ( input: EncryptStructureInput )
 returns (output: Result<EncryptStructureOutput, Error>)
 modifies this`EncryptStructureHistoricalCallEvents
 ensures EncryptStructureEnsuresPublicly(input, output)
 ensures
 && 0 < |EncryptStructureHistoricalCallEvents|
 && Last(EncryptStructureHistoricalCallEvents) == DafnyCallEvent(input, output)
 
 ghost var DecryptStructureHistoricalCallEvents: seq<DafnyCallEvent<DecryptStructureInput, Result<DecryptStructureOutput, Error>>>
 predicate DecryptStructureEnsuresPublicly(input: DecryptStructureInput, output: Result<DecryptStructureOutput, Error>)
 // The public method to be called by library consumers
 method DecryptStructure ( input: DecryptStructureInput )
 returns (output: Result<DecryptStructureOutput, Error>)
 modifies this`DecryptStructureHistoricalCallEvents
 ensures DecryptStructureEnsuresPublicly(input, output)
 ensures
 && 0 < |DecryptStructureHistoricalCallEvents|
 && Last(DecryptStructureHistoricalCallEvents) == DafnyCallEvent(input, output)
 
}
 datatype StructuredEncryptionConfig = | StructuredEncryptionConfig (
 
 )
 type Terminal = seq<uint8>
 datatype Error =
 // Local Error structures are listed here
 
 // Any dependent models are listed here
 
 // The Collection error is used to collect several errors together
 // This is useful when composing OR logic.
 // Consider the following method:
 // 
 // method FN<I, O>(n:I)
 //   returns (res: Result<O, Types.Error>)
 //   ensures A(I).Success? ==> res.Success?
 //   ensures B(I).Success? ==> res.Success?
 //   ensures A(I).Failure? && B(I).Failure? ==> res.Failure?
 // 
 // If either A || B is successful then FN is successful.
 // And if A && B fail then FN will fail.
 // But what information should FN transmit back to the caller?
 // While it may be correct to hide these details from the caller,
 // this can not be the globally correct option.
 // Suppose that A and B can be blocked by different ACLs,
 // and that their representation of I is only eventually consistent.
 // How can the caller distinguish, at a minimum for logging,
 // the difference between the four failure modes?
 // || (!access(A(I)) && !access(B(I)))
 // || (!exit(A(I)) && !exit(B(I)))
 // || (!access(A(I)) && !exit(B(I)))
 // || (!exit(A(I)) && !access(B(I)))
 | Collection(list: seq<Error>)
 // The Opaque error, used for native, extern, wrapped or unknown errors
 | Opaque(obj: object)
 type OpaqueError = e: Error | e.Opaque? witness *
}
 abstract module AwsCryptographyStructuredEncryptionAbstract
 {
 import opened Wrappers
 import opened StandardLibrary.UInt
 import opened UTF8
 import opened Types = AwsCryptographyStructuredEncryptionTypes
 function method DefaultStructuredEncryptionConfig(): StructuredEncryptionConfig
 method StructuredEncryption(config: StructuredEncryptionConfig := DefaultStructuredEncryptionConfig())
 returns (res: Result<IStructuredEncryptionClient, Error>)
 ensures res.Success? ==> fresh(res.value)
}

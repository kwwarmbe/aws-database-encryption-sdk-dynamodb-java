// Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
// Do not modify this file. This file is machine generated, and any changes to it will be overwritten.
using System;
using System.IO;
using System.Collections.Generic;
using AWS.Cryptography.DbEncryptionSDK.StructuredEncryption;
using software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types;
namespace AWS.Cryptography.DbEncryptionSDK.StructuredEncryption
{
  public class StructuredEncryption
  {
    private readonly software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types.IStructuredEncryptionClient _impl;
    public StructuredEncryption(software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types.IStructuredEncryptionClient impl)
    {
      this._impl = impl;
    }
    public software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types.IStructuredEncryptionClient impl()
    {
      return this._impl;
    }
    public StructuredEncryption(AWS.Cryptography.DbEncryptionSDK.StructuredEncryption.StructuredEncryptionConfig input)
    {
      software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types._IStructuredEncryptionConfig internalInput = TypeConversion.ToDafny_N3_aws__N12_cryptography__N15_dbEncryptionSdk__N20_structuredEncryption__S26_StructuredEncryptionConfig(input);
      var result = software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.__default.StructuredEncryption(internalInput);
      if (result.is_Failure) throw TypeConversion.FromDafny_CommonError(result.dtor_error);
      this._impl = result.dtor_value;
    }
    public AWS.Cryptography.DbEncryptionSDK.StructuredEncryption.EncryptStructureOutput EncryptStructure(AWS.Cryptography.DbEncryptionSDK.StructuredEncryption.EncryptStructureInput input)
    {
      software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types._IEncryptStructureInput internalInput = TypeConversion.ToDafny_N3_aws__N12_cryptography__N15_dbEncryptionSdk__N20_structuredEncryption__S21_EncryptStructureInput(input);
      Wrappers_Compile._IResult<software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types._IEncryptStructureOutput, software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types._IError> result = _impl.EncryptStructure(internalInput);
      if (result.is_Failure) throw TypeConversion.FromDafny_CommonError(result.dtor_error);
      return TypeConversion.FromDafny_N3_aws__N12_cryptography__N15_dbEncryptionSdk__N20_structuredEncryption__S22_EncryptStructureOutput(result.dtor_value);
    }
    public AWS.Cryptography.DbEncryptionSDK.StructuredEncryption.DecryptStructureOutput DecryptStructure(AWS.Cryptography.DbEncryptionSDK.StructuredEncryption.DecryptStructureInput input)
    {
      software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types._IDecryptStructureInput internalInput = TypeConversion.ToDafny_N3_aws__N12_cryptography__N15_dbEncryptionSdk__N20_structuredEncryption__S21_DecryptStructureInput(input);
      Wrappers_Compile._IResult<software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types._IDecryptStructureOutput, software.amazon.cryptography.dbencryptionsdk.structuredencryption.internaldafny.types._IError> result = _impl.DecryptStructure(internalInput);
      if (result.is_Failure) throw TypeConversion.FromDafny_CommonError(result.dtor_error);
      return TypeConversion.FromDafny_N3_aws__N12_cryptography__N15_dbEncryptionSdk__N20_structuredEncryption__S22_DecryptStructureOutput(result.dtor_value);
    }
  }
}

// Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
include "../Model/AwsCryptographyDynamoDbEncryptionTypes.dfy"

module DdbMiddlewareConfig {
  import opened Wrappers
  import opened AwsCryptographyDynamoDbEncryptionTypes
  import DynamoDbItemEncryptor
  import EncTypes = AwsCryptographyDynamoDbItemEncryptorTypes
  
  datatype TableConfig = TableConfig(
    partitionKeyName: string,
    sortKeyName: Option<string>,
    itemEncryptor: DynamoDbItemEncryptor.DynamoDbItemEncryptorClient
    // TODO beacon config
  )

  predicate ValidTableConfig?(config: TableConfig) {
    var encryptorConfig := config.itemEncryptor.config;
    && config.partitionKeyName == encryptorConfig.partitionKeyName
    && config.sortKeyName == encryptorConfig.sortKeyName
    && config.itemEncryptor.ValidState()
  }

  type ValidTableConfig = c: TableConfig | ValidTableConfig?(c) witness *

  function ModifiesConfig(config: Config) : set<object>
  {
    set t <- config.tableEncryptionConfigs.Keys, o <- config.tableEncryptionConfigs[t].itemEncryptor.Modifies :: o
  }

  predicate ValidConfig?(config: Config)
  {
    && (forall tableName <- config.tableEncryptionConfigs ::
        config.tableEncryptionConfigs[tableName].itemEncryptor.config.tableName == tableName)
    && (forall t :: t in config.tableEncryptionConfigs.Keys ==>
        config.tableEncryptionConfigs[t].itemEncryptor.ValidState())
  }


  datatype Config = Config(
    tableEncryptionConfigs: map<string, ValidTableConfig>
    // TODO allowed passthrough tables
  )

  function method MapError<T>(r : Result<T, EncTypes.Error>) : Result<T, Error> {
    r.MapFailure(e => AwsCryptographyDynamoDbItemEncryptor(e))
  }

  function method MapString<T>(r : Result<T, string>) : Result<T, Error> {
    r.MapFailure(e => Error.DynamoDbEncryptionException(message := e))
  }

  // string to Error
  function method E(s : string) : Error {
    DynamoDbEncryptionException(message := s)
  }

  function method MakeError<X>(s : string) : Result<X, Error>
  {
    Failure(Error.DynamoDbEncryptionException(message := s))
  }

  predicate SameOption<X>(x : Option<X>, y : Option<X>)
  {
    (x.Some? && y.Some?) || (x.None? && y.None?)
  }
}
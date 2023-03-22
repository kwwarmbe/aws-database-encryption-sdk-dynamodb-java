// Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
// Do not modify this file. This file is machine generated, and any changes to it will be overwritten.
package software.amazon.cryptography.dynamoDbEncryption.model;

import java.util.Objects;
import software.amazon.awssdk.services.dynamodb.model.UpdateTableRequest;

public class UpdateTableInputTransformOutput {
  private final UpdateTableRequest transformedInput;

  protected UpdateTableInputTransformOutput(BuilderImpl builder) {
    this.transformedInput = builder.transformedInput();
  }

  public UpdateTableRequest transformedInput() {
    return this.transformedInput;
  }

  public Builder toBuilder() {
    return new BuilderImpl(this);
  }

  public static Builder builder() {
    return new BuilderImpl();
  }

  public interface Builder {
    Builder transformedInput(UpdateTableRequest transformedInput);

    UpdateTableRequest transformedInput();

    UpdateTableInputTransformOutput build();
  }

  static class BuilderImpl implements Builder {
    protected UpdateTableRequest transformedInput;

    protected BuilderImpl() {
    }

    protected BuilderImpl(UpdateTableInputTransformOutput model) {
      this.transformedInput = model.transformedInput();
    }

    public Builder transformedInput(UpdateTableRequest transformedInput) {
      this.transformedInput = transformedInput;
      return this;
    }

    public UpdateTableRequest transformedInput() {
      return this.transformedInput;
    }

    public UpdateTableInputTransformOutput build() {
      if (Objects.isNull(this.transformedInput()))  {
        throw new IllegalArgumentException("Missing value for required field `transformedInput`");
      }
      return new UpdateTableInputTransformOutput(this);
    }
  }
}

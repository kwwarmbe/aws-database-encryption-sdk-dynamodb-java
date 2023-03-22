// Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
// Do not modify this file. This file is machine generated, and any changes to it will be overwritten.
package software.amazon.cryptography.dynamoDbEncryption.model;

import java.util.Objects;
import software.amazon.awssdk.services.dynamodb.model.CreateTableRequest;
import software.amazon.awssdk.services.dynamodb.model.CreateTableResponse;

public class CreateTableOutputTransformInput {
  private final CreateTableResponse sdkOutput;

  private final CreateTableRequest originalInput;

  protected CreateTableOutputTransformInput(BuilderImpl builder) {
    this.sdkOutput = builder.sdkOutput();
    this.originalInput = builder.originalInput();
  }

  public CreateTableResponse sdkOutput() {
    return this.sdkOutput;
  }

  public CreateTableRequest originalInput() {
    return this.originalInput;
  }

  public Builder toBuilder() {
    return new BuilderImpl(this);
  }

  public static Builder builder() {
    return new BuilderImpl();
  }

  public interface Builder {
    Builder sdkOutput(CreateTableResponse sdkOutput);

    CreateTableResponse sdkOutput();

    Builder originalInput(CreateTableRequest originalInput);

    CreateTableRequest originalInput();

    CreateTableOutputTransformInput build();
  }

  static class BuilderImpl implements Builder {
    protected CreateTableResponse sdkOutput;

    protected CreateTableRequest originalInput;

    protected BuilderImpl() {
    }

    protected BuilderImpl(CreateTableOutputTransformInput model) {
      this.sdkOutput = model.sdkOutput();
      this.originalInput = model.originalInput();
    }

    public Builder sdkOutput(CreateTableResponse sdkOutput) {
      this.sdkOutput = sdkOutput;
      return this;
    }

    public CreateTableResponse sdkOutput() {
      return this.sdkOutput;
    }

    public Builder originalInput(CreateTableRequest originalInput) {
      this.originalInput = originalInput;
      return this;
    }

    public CreateTableRequest originalInput() {
      return this.originalInput;
    }

    public CreateTableOutputTransformInput build() {
      if (Objects.isNull(this.sdkOutput()))  {
        throw new IllegalArgumentException("Missing value for required field `sdkOutput`");
      }
      if (Objects.isNull(this.originalInput()))  {
        throw new IllegalArgumentException("Missing value for required field `originalInput`");
      }
      return new CreateTableOutputTransformInput(this);
    }
  }
}

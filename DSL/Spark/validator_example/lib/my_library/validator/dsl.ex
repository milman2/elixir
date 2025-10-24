defmodule MyLibrary.Validator.Dsl do
  @moduledoc """
  Spark DSL Extension for defining validators

  공식 문서 예제: https://hexdocs.pm/spark/get-started-with-spark.html
  """

  defmodule Field do
    @moduledoc "A field definition for validation"
    # The __spark_metadata__ field is required for Spark entities
    # It stores source location information for better error messages and tooling
    defstruct [:name, :type, :transform, :check, :__spark_metadata__]
  end

  @field %Spark.Dsl.Entity{
    name: :field,
    args: [:name, :type],
    target: Field,
    describe: "A field that is accepted by the validator",
    schema: [
      name: [
        type: :atom,
        required: true,
        doc: "The name of the field"
      ],
      type: [
        type: {:in, [:integer, :string]},
        required: true,
        doc: "The type of the field"
      ],
      check: [
        type: {:fun, 1},
        doc: "A function that can be used to check if the value is valid after type validation."
      ],
      transform: [
        type: {:fun, 1},
        doc: "A function that will be used to transform the value after successful validation"
      ]
    ]
  }

  @fields %Spark.Dsl.Section{
    name: :fields,
    schema: [
      required: [
        type: {:list, :atom},
        default: [],
        doc: "The fields that must be provided for validation to succeed"
      ]
    ],
    entities: [
      @field
    ],
    describe: "Configure the fields that are supported and required"
  }

  use Spark.Dsl.Extension,
    sections: [@fields],
    transformers: [
      MyLibrary.Validator.Transformers.AddId,
      MyLibrary.Validator.Transformers.GenerateValidate
    ],
    verifiers: [
      MyLibrary.Validator.Verifiers.VerifyRequired
    ]
end

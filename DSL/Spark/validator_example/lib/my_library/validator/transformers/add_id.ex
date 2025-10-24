defmodule MyLibrary.Validator.Transformers.AddId do
  @moduledoc """
  Transformer that automatically adds an :id field to all validators

  공식 문서 예제: https://hexdocs.pm/spark/get-started-with-spark.html#transformers
  """

  use Spark.Dsl.Transformer

  # dsl_state here is a map of the underlying DSL data
  def transform(dsl_state) do
    {:ok,
     Spark.Dsl.Transformer.add_entity(dsl_state, [:fields], %MyLibrary.Validator.Dsl.Field{
       name: :id,
       type: :string,
       transform: nil,
       check: nil
     })}
  end
end

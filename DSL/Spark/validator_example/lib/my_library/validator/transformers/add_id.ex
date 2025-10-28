# Transformer : Spark.Dsl.Transformer
defmodule MyLibrary.Validator.Transformers.AddId do
  @moduledoc """
  Transformer that automatically adds an :id field to all validators

  공식 문서 예제: https://hexdocs.pm/spark/get-started-with-spark.html#transformers
  """

  use Spark.Dsl.Transformer
  # transform/1, before?/1, after?/1, after_compile?/1
  # add_entity/3, remove_entity/2, replace_entity/4, get_entities/2, build_entity/4
  # get_option/4, set_option/4, fetch_option/3
  # eval/3
  # persist/3, get_persisted/3, fetch_persisted/2

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

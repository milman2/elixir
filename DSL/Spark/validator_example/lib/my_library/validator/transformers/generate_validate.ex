defmodule MyLibrary.Validator.Transformers.GenerateValidate do
  @moduledoc """
  Transformer that generates a validate/1 function for each validator

  공식 문서 예제: https://hexdocs.pm/spark/get-started-with-spark.html#generating-code-into-the-module
  """

  use Spark.Dsl.Transformer

  def transform(dsl_state) do
    validate = quote do
      def validate(data) do
        # Our generated code can be very simple
        # because we can get all the info we need from the module
        # in our regular Elixir code.
        MyLibrary.Validator.validate(__MODULE__, data)
      end
    end

    {:ok, Spark.Dsl.Transformer.eval(dsl_state, [], validate)}
  end
end

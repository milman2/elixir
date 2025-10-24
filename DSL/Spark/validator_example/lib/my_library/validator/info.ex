defmodule MyLibrary.Validator.Info do
  @moduledoc """
  Info module for the Validator DSL

  Provides convenient functions to query DSL information.

  공식 문서 예제: https://hexdocs.pm/spark/get-started-with-spark.html#getting-a-nice-interface-to-your-dsl
  """

  use Spark.InfoGenerator,
    extension: MyLibrary.Validator.Dsl,
    sections: [:fields]
end

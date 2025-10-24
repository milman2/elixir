defmodule MyApp.PersonValidator do
  @moduledoc """
  공식 문서의 PersonValidator 예제

  https://hexdocs.pm/spark/get-started-with-spark.html
  """

  use MyLibrary.Validator

  fields do
    required [:name]
    field :name, :string

    field :email, :string do
      check &String.contains?(&1, "@")
      transform &String.trim/1
    end

    # This syntax is also supported
    # field :email, :string, check: &String.contains?(&1, "@"), transform: &String.trim/1
  end
end

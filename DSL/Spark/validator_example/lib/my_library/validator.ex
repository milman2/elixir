# DSL Module : Spark.Dsl
defmodule MyLibrary.Validator do
  @moduledoc """
  A DSL for defining data validators using Spark

  공식 문서 예제: https://hexdocs.pm/spark/get-started-with-spark.html

  ## 사용 예제

      defmodule MyApp.PersonValidator do
        use MyLibrary.Validator

        fields do
          required [:name]
          field :name, :string

          field :email, :string do
            check &String.contains?(&1, "@")
            transform &String.trim/1
          end
        end
      end

      MyApp.PersonValidator.validate(%{name: "Zach", email: " foo@example.com "})
      # {:ok, %{name: "Zach", email: "foo@example.com", id: nil}}
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [MyLibrary.Validator.Dsl]
    ]

  @doc """
  Validates the given data against the validator module's rules
  """
  def validate(module, data) do
    fields = MyLibrary.Validator.Info.fields(module)
    required = MyLibrary.Validator.Info.fields_required!(module)

    case Enum.reject(required, &Map.has_key?(data, &1)) do
      [] ->
        validate_fields(fields, data)

      missing_required_fields ->
        {:error, :missing_required_fields, missing_required_fields}
    end
  end

  defp validate_fields(fields, data) do
    Enum.reduce_while(fields, {:ok, %{}}, fn field, {:ok, acc} ->
      case Map.fetch(data, field.name) do
        {:ok, value} ->
          case validate_value(field, value) do
            {:ok, value} ->
              {:cont, {:ok, Map.put(acc, field.name, value)}}

            :error ->
              {:halt, {:error, :invalid, field.name}}
          end

        :error ->
          # Field not provided, use nil for optional fields
          {:cont, {:ok, Map.put(acc, field.name, nil)}}
      end
    end)
  end

  defp validate_value(field, value) do
    with true <- type_check(field, value),
         true <- check(field, value) do
      {:ok, transform(field, value)}
    else
      _ ->
        :error
    end
  end

  defp type_check(%{type: :string}, value) when is_binary(value) do
    true
  end

  defp type_check(%{type: :integer}, value) when is_integer(value) do
    true
  end

  defp type_check(_, _), do: false

  defp check(%{check: check}, value) when is_function(check, 1) do
    check.(value)
  end

  defp check(_, _), do: true

  defp transform(%{transform: transform}, value) when is_function(transform, 1) do
    transform.(value)
  end

  defp transform(_, value), do: value
end

# 방법 1 : Extension API 사용
# Get all field entities
# fields = Spark.Dsl.Extension.get_entities(MyApp.PersonValidator, :fields)

# Get a specific option
# required_fields = Spark.Dsl.Extension.get_opt(MyApp.PersonValidator, [:fields], :required)

# 방법 2 : InfoGenerator 사용
# Get all field entities
# fields = MyLibrary.Validator.Info.fields(MyApp.PersonValidator)

# Get required fields with error handling
# MyLibrary.Validator.Info.fields_required(MyApp.PersonValidator)

# Get required fields without error handling
# required_fields = MyLibrary.Validator.Info.fields_required!(MyApp.PersonValidator)

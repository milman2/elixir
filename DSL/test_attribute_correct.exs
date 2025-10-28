defmodule CorrectDSL do
  defmacro schema(name, do: block) do
    quote do
      # ✅ Module.put_attribute는 호출하는 모듈에 설정됨!
      Module.put_attribute(__MODULE__, :table_name, unquote(name))
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
      unquote(block)
      @before_compile CorrectDSL
    end
  end

  defmacro field(name, type) do
    quote do
      Module.put_attribute(__MODULE__, :fields, {unquote(name), unquote(type)})
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def table_name, do: @table_name
      def fields, do: @fields |> Enum.reverse()
    end
  end
end

defmodule TestSchema2 do
  import CorrectDSL

  schema "products" do
    field :name, :string
    field :price, :integer
  end
end

# 확인
IO.puts("\n=== ✅ 올바른 방법 결과 ===")
IO.puts("Table name: #{TestSchema2.table_name()}")
IO.inspect(TestSchema2.fields(), label: "Fields")

defmodule MySchemaDSL do
  defmacro schema(name, do: block) do
    quote do
      # __MODULE__은 매크로를 호출하는 모듈을 가리킴.
      # 동적으로 attribute를 설정하려면 Module.put_attribute를 사용해야 함.
      Module.put_attribute(__MODULE__, :table_name, unquote(name)) # @table_name unquote(name)
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
      unquote(block)
      @before_compile MySchemaDSL
    end
  end

  defmacro field(name, type) do
    quote do
      Module.put_attribute(__MODULE__, :fields, {unquote(name), unquote(type)}) # @fields {unquote(name), unquote(type)}
    end
  end

  # 컴파일 타임에 실행됨
  defmacro __before_compile__(_env) do
    quote do
      # Module attribute 값을 함수로 저장
      def table_name do
        @table_name
      end

      def fields do
        @fields |> Enum.reverse()  # accumulate는 역순으로 저장되므로 뒤집기
      end

      def generate do
        table = table_name()
        fields = fields()
        IO.puts("\n=== Schema Definition ===")
        IO.puts("Table: #{table}")
        IO.puts("Fields:")
        Enum.each(fields, fn {name, type} ->
          IO.puts("  - #{name}: #{type}")
        end)
        {table, fields}
      end
    end
  end
end

defmodule UserSchema do
  import MySchemaDSL

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
  end
end

# 이제 작동합니다!
# UserSchema.generate()

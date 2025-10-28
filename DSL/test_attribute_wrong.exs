defmodule WrongDSL do
  defmacro schema(name, do: block) do
    quote do
      # ❌ 이렇게 하면 WrongDSL 모듈에 설정됨!
      @table_name unquote(name)
      unquote(block)
    end
  end

  defmacro field(name, type) do
    quote do
      @fields {unquote(name), unquote(type)}
    end
  end
end

defmodule TestSchema1 do
  import WrongDSL

  schema "users" do
    field :name, :string
  end
end

# 확인
IO.inspect(TestSchema1.__info__(:attributes), label: "TestSchema1 attributes")

# WrongDSL에 설정되었는지 확인
try do
  IO.inspect(WrongDSL.__info__(:attributes), label: "WrongDSL attributes")
rescue
  e -> IO.puts("WrongDSL attributes 확인 실패: #{inspect(e)}")
end

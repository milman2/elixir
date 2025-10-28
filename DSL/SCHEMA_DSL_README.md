# Schema DSL 예제

`@before_compile` 훅을 사용한 실전 DSL 구현 예제입니다.

> 📖 **관련 문서:** `@attribute` vs `Module.put_attribute` 차이는 [ATTRIBUTE_COMPARISON.md](./ATTRIBUTE_COMPARISON.md)를 참고하세요.

---

## 🎯 핵심 문제

Module attribute는 **컴파일 타임**에만 접근 가능하지만, DSL은 **런타임**에 값이 필요합니다.

**해결책:** `@before_compile` 훅으로 attribute를 함수로 변환!

---

## 📝 완전한 구현

```elixir
defmodule MySchemaDSL do
  defmacro schema(name, do: block) do
    quote do
      Module.put_attribute(__MODULE__, :table_name, unquote(name))
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
      unquote(block)
      @before_compile MySchemaDSL  # ← 컴파일 직전 실행
    end
  end

  defmacro field(name, type) do
    quote do
      Module.put_attribute(__MODULE__, :fields, {unquote(name), unquote(type)})
    end
  end

  # 컴파일 타임에 실행되는 매크로
  defmacro __before_compile__(_env) do
    quote do
      # Module attribute 값을 함수로 "고정"
      def table_name do
        @table_name
      end

      def fields do
        @fields |> Enum.reverse()
      end

      def generate do
        table = table_name()    # ✅ 이제 작동!
        fields = fields()       # ✅ 이제 작동!
        {table, fields}
      end
    end
  end
end
```

---

## 🔑 @before_compile 동작 원리

```
컴파일 타임                      런타임
│                               │
├─ @table_name 설정            │
├─ @fields 누적                 │
├─ @before_compile 실행        │
│  └─ attribute → 함수 변환    │
├─ 컴파일 완료                  │
│                               ├─ table_name() 호출 ✅
│                               ├─ fields() 호출 ✅
│                               └─ Module.get_attribute() ❌
```

**핵심:** 컴파일이 끝나기 **직전**에 attribute를 함수로 변환하여 런타임에 사용 가능하게 만듦

---

## 📝 사용 예제

### 정의
```elixir
defmodule UserSchema do
  import MySchemaDSL

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
  end
end
```

### 사용
```elixir
# IEx
iex> c "my_schema.exs"
[MySchemaDSL, UserSchema]

iex> UserSchema.generate()

=== Schema Definition ===
Table: users
Fields:
  - name: string
  - age: integer
  - email: string
{"users", [name: :string, age: :integer, email: :string]}

iex> UserSchema.table_name()
"users"

iex> UserSchema.fields()
[name: :string, age: :integer, email: :string]
```

---

## 🚀 실행 방법

```bash
cd /home/milman2/elixir/DSL

# 방법 1: Elixir 직접 실행
elixir my_schema.exs

# 방법 2: IEx에서 실행
iex
iex> c "my_schema.exs"
iex> UserSchema.generate()
```

---

## 💡 추가 기능 아이디어

### 1. 타입 검증 추가
```elixir
defmacro field(name, type) when type in [:string, :integer, :boolean] do
  # ...
end
```

### 2. SQL 생성
```elixir
def generate_sql do
  table = table_name()
  fields_sql = 
    fields()
    |> Enum.map(fn {name, type} -> "#{name} #{sql_type(type)}" end)
    |> Enum.join(", ")
  
  "CREATE TABLE #{table} (#{fields_sql});"
end

defp sql_type(:string), do: "VARCHAR(255)"
defp sql_type(:integer), do: "INTEGER"
```

### 3. Ecto Schema 생성
```elixir
def generate_ecto_schema do
  # Ecto schema 코드 생성
end
```

---

## 📚 관련 자료

- [Elixir Module Attribute](https://elixir-lang.org/getting-started/module-attributes.html)
- [Metaprogramming Elixir](https://pragprog.com/titles/cmelixir/metaprogramming-elixir/)
- `@before_compile` 문서: https://hexdocs.pm/elixir/Module.html#module-before_compile

---

## ✅ 핵심 정리

| 개념 | 설명 |
|-----|-----|
| **Module attribute** | 컴파일 타임에만 접근 가능 |
| **@before_compile** | 컴파일 직전에 attribute → 함수 변환 |
| **accumulate: true** | 여러 값 누적 (field 같은 반복 호출) |
| **Enum.reverse()** | 누적된 순서 복원 |

> 💡 이 패턴은 Ecto, Phoenix, Spark 등 모든 Elixir DSL의 핵심입니다!


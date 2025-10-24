# Meta Programming
- generate code at compile time
- represent expression
- navigate abstract syntax tree(AST)
- inject values into quoted code
- macro
- domain specific language(DSL)
- generate code at run time
# quote/2,  unquote/1, Macro.to_string/1
- qoute : 코드를 AST로 표현(변환)
- unquote : quote 내부에서 **외부 값을 삽입**할 때 사용
- represent an Elixir program by its own data structure 
- AST
- {function call, context, [arguements]}
- [atom | tuple, list, list | atom]
    - first element : an atom or another tuple
    - second element : keyword list containing metadata
    - third element : a list of arguments for the function call or an atom

```elixir
quote do
    # block
end

quote do: sum(1, 2, 3)
quote do: 1 + 2
quote do: %{1 => 2}
quote do: x

quote do: sum(1, 2 + 3, 4)

# textual code representation
Macro.to_string(quote do: sum(1, 2 + 3, 4))

# literals
quote do: :sum         #=> Atoms
quote do: 1.0          #=> Numbers
quote do: [1, 2]       #=> Lists
quote do: "string"     #=> Strings
quote do: {key, value} #=> Tuples with tow elements
```

```elixir
number = 13
Macro.to_string(quote do: 11 + unquote(number))

fun = :hello
Macro.to_string(quote do: unquote(fun)(:world))

inner = [3, 4, 5]
Macro.to_string(quote do: [1, 2, unquote_splicing(inner), 6]) # unquote_splicing
```

# Macro.escape
```elixir
# problem
map = %{1 => 2}
quote do
  IO.inspect(unquote(map))
end
# solution
map = %{hello: :world}
escaped = Macro.escape(map)
quote do
  IO.inspect(unquote(escaped))
end

# problem
this_val = {:a, :b, :c}
quote do: this_val
# solution
this_val = {:a, :b, :c}
this_val |> Macro.escape()
this_val_ast = this_val |> Macro.escape()
quote do
  unquote(this_val_ast)
end
```

# Kernel.is_struct/2
```elixir
defmodule Human do
  @enforce_keys [:name, :age]
  defstruct name: nil, age: 0
  @type t :: %__MODULE__{name: String.t(), age: non_neg_integer}
end

mary = %Human{name: "Mary", age: 28}
IO.inspect(mary, structs: false)
```

# Kernel.tab/2
```elixir
%{a: 1}
|> Map.update!(:a, &(&1 + 2))
|> tap(&IO.inspect(&1.a))
|> Map.update!(:a, &(&1 * 2))
```

# 
```elixir
kv = [foo: 1, bar: 2]
defmodule M do
  defmacro defkv(kv) do
    Enum.map(kv, fn {k, v} ->
      quote do
        def unquote(k)(), do: unquote(v)
      end
    end)
  end
end

defmodule M2 do
  require M
  M.defkv [foo: 1, bar: 2]
end

M2.foo()
M2.bar()

defmodule FooBar do
  kv = [foo: 1, bar: 2]
  Enum.each(kv, fn {k, v} -> 
    def unquote(k)(), do: unquote(v)
  end)
end

FooBar.foo()
FooBar.bar()

```

# Macro
- receive quoted expressions
- inject them into the quote
- and finally return another quoted expresson
- compile time code manipulation

```shell
elixir macros.exs
iex macros.exs
```

- if/2, defmacro/2, def/2, defprotocol/2
```elixir
defmacro if(clause, do: expression) do
  quote do
    case clause do
      x when x in [false, nil] -> nil
      _ -> unquote(expression)
  end
end
```
- defmacro
- Macro.expand_once/2, Macro.expand/2
- Kernel.SpecialForms
- var!/2, alias!/2
- Macro.var/2
- Macro.unique_var/2
- Macro.Env # __ENV__
- defmacrop

```elixir
Kernel.__info__(:macros)
Kernel.SpecialForms.__info__(:macros)
```

```elixir
x = 8
quote do
  unquote(x) in [1, 2]
end
|> Code.eval_quoted()


# To explicitly pull values from outside `quote` into it from its variable binding at runtime
# NOT changed the value of `x` outside of the quoted expression
x = 8
quote do
  var!(x) in [1, 2] # var!
end
|> Code.eval_quoted(x: 2)
x

x = 3
quote do
  x = unquote(x)
  x = x * x
end
|> Code.eval_quoted()
|> elem(0)
x

# Break macro hygiene at runtime with var!/1
x = 3
defmodule M do
  defmacro square(x) do
    quote do
      var!(x) = unquote(x) * unquote(x)
    end
  end
end

require M
M.square(x) |> Code.eval_quoted()
x

# bind_quoted
x = 3
defmodule M2 do
  defmacro square(x) do
    quote bind_quoted: [x: x] do
      var!(x) = x * x
    end
  end
end

require M
M.square(x) |> Code.eval_quoted()
x

quote do
  17 + 18
end
|> Code.eval_quoted()
|> elem(0)

"17" |> Code.string_to_quoted()
"17 |> Integer.to_string()" |> Code.string_to_quoted() |> elem(1) |> Code.eval_quoted() |> elem(0) # cf. Macro.to_string

quote(do: if(true, do: 1, else: 0))
|> Macro.expand(__ENV__)

quote do: [{:red_sox, :good}, {:yankees, :evil}]
quote do: [red_sox: :good, yankees: :evil]

"efg" |> IEx.Info.info()
~c"efg" |> IEx.Info.info() # 'efg' |> IEx.Info.info()
```

## use
- 모듈을 가져오고, 그 모듈이 정의한 매크로를 실행하여 현재 모듈에 코드를 삽입하는 매크로 호출 방식
```elixir
defmodule MyFeature do
  defmacro __using__(_opts) do
    quote do
      def hello, do: IO.puts("Hello from MyFeature!")
    end
  end
end

defmodule MyApp do
  use MyFeature
end

MyApp.hello()  # 출력: Hello from MyFeature!
```

# DSL
- Module
    - @before_compile
    - @on_definition
    - @after_comple
- Macro
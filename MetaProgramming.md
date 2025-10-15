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
Macro.to_string(quote do: [1, 2, unquote_splicing(inner), 6])
```

# Macro.escape
- problem
```elixir
map = %{1 => 2}
quote do
  IO.inspect(unquote(map))
end
```
- solution
```elixir
map = %{hello: :world}
escaped = Macro.escape(map)
quote do
  IO.inspect(unquote(escaped))
end
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

# DSL
- Module
    - @before_compile
    - @on_definition
    - @after_comple
- Macro
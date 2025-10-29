# Module and functions
- defmodule
- def : 첫 글자 lowercase or underscore
- defp

- first letter of a module name must be uppercase.
- first letter of a function name must be lowercase.

# Function definition
- Function declarations also support guards and multiple clauses.
```elixir
defmodule Math do
  def zero?(0) do
    true
  end

  def zero?(x) when is_integer(x) do
    false
  end
end

IO.puts Math.zero?(0)         #=> true
IO.puts Math.zero?(1)         #=> false
IO.puts Math.zero?([1, 2, 3]) #=> ** (FunctionClauseError)
IO.puts Math.zero?(0.0)       #=> ** (FunctionClauseError)
```
## do-block syntax
```elixir
defmodule Math do
  def zero?(0), do: true
  def zero?(x) when is_integer(x), do: false
end
```

## Default arguments
```elixir
defmodule Concat do
  def join(a, b, sep \\ " ") do
    a <> sep <> b
  end
end

IO.puts(Concat.join("Hello", "world"))      #=> Hello world
IO.puts(Concat.join("Hello", "world", "_")) #=> Hello_world
```

```elixir
defmodule Concat do
  # If a function with default values has multiple clauses
  # A function head declaring defaults
  def join(a, b, sep \\ " ")

  def join(a, b, _sep) when b == "" do
    a
  end

  def join(a, b, sep) do
    a <> sep <> b
  end
end

IO.puts(Concat.join("Hello", ""))           #=> Hello
IO.puts(Concat.join("Hello", "world"))      #=> Hello world
IO.puts(Concat.join("Hello", "world", "_")) #=> Hello_world
```

# Aliases
```elixir
is_atom(String)
:"Elixir.String" == String

List.flatten([1, [2], 3])
:"Elixir.List".flatten([1, [2], 3])
:lists.flatten([1, [2], 3])
```
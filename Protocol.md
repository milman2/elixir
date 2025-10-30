# Protocol
- allow us to extend the original behavior for as many data types as we need
- dispatching will always be based on the data type of the first input.
```elixir
defprotocol Utility do
    @spec type(t) :: String.t()
    def type(value)
end

defimpl Utility, for: BitString do
    def type(_value), do: "string"
end

defimpl Utility, for: Integer do
    def type(_value), do: "integer"
end

Utility.type("foo")
Utility.type(123)
```


```elixir
defprotocol Size do
    @doc "Calculates the size (and not the length!) of a data structure"
    def size(data)
end

defimpl Size, for: BitString do
  def size(string), do: byte_size(string)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end

Size.size("foo")
Size.size({:ok, "hello"})
Size.size(%{label: "some label"})
```

## Elixir data types
- Atom
- BitString
- Float
- Function
- Integer
- List
- Map
- PID
- Port
- Reference
- Tuple

## Protocols and structs
```elixir
Size.size(%{})
set = %MapSet{} = MapSet.new
Size.size(set) # Protocol.UndefinedError


defimpl Size, for: MapSet do
  def size(set), do: MapSet.size(set)
end
```

## Implementing Any
```elixir
defimpl Size, for: Any do
  def size(_), do: 0
end

defmodule OtherUser do
  @derive [Size]
  defstruct [:name, :age]
end
```

## Fallback to Any
```elixir
defprotocol Size do
  @fallback_to_any true
  def size(data)
end
```

## Built-in protocols
- Enumerable # Enum.map, Enum.reduce
- String.Chars # to_string
- Inspect # inspect

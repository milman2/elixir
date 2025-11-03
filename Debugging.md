# IO.inspect/2
```elixir
(1..10)
|> IO.inspect()
|> Enum.map(fn x -> x * 2 end)
|> IO.inspect()
|> Enum.sum()
|> IO.inspect()

[1, 2, 3]
|> IO.inspect(label: "before")
|> Enum.map(&(&1 * 2))
|> IO.inspect(label: "after")
|> Enum.sum

def some_function(a, b, c) do
  IO.inspect(binding())
end
```

# dbg/2
```elixir
feature = %{name: :dbg, inspiration: "Rust"}
dbg(feature)
dbg(Map.put(feature, :in_version, "1.14.0"))

__ENV__.file
|> String.split("/", trim: true)
|> List.last()
|> File.exists?()
|> dbg()
```

# Pry
```shell
iex --dbg pry
iex --dbg pry -S mix
```

# Breakpoint

# Observer
```elixir
:oberser.start()
```
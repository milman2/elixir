# Enumerable protocol 
- transform
- sort
- group
- filter
- retrieve items from enumberables

```elixir
Enum.map(%{1 => 2, 3 => 4}, fn {k, v} -> k * v end)
```

## Eager vs Lazy
- All the functions in the Enum module are eager.

```elixir
odd? = fn x -> rem(x, 2) != 0 end
1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum()
```

## The pipe operator
- |>

# Stream
- lazy operations

```elixir
1..100_000 |> Stream.map(&(&1 * 3)) |> Stream.filter(odd?) |> Enum.sum()
```
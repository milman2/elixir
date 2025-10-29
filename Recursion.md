# Recursion
- loop
## Reduce and map algorithms
- reducing
- mapping
```elixir
Enum.reduce([1,2,3], 0, fn x, acc -> x + acc end)
Enum.map([1,2,3], fn x -> x * 2 end)

# using the capture syntax
Enum.reduce([1, 2, 3], 0, &+/2)
Enum.map([1, 2, 3], &(&1 * 2))
```

## Tail call optimization

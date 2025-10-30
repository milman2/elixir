# Comprehension
- generator
- filter
- collectable

```elixir
for n <- [1, 2, 3, 4], do: n * n

values = [good: 1, good: 2, bad: 3, good: 4]
for {:good, n} <- values, do: n * n

for n <- 0..5, rem(n, 3) == 0, do: n * n

dirs = ["/home/mikey", "/home/james"]
for dir <- dirs,
    file <- File.ls!(dir),
    path = Path.join(dir, file),
    File.regular?(path) do
  File.stat!(path).size
end

for i <- [:a, :b, :c], j <- [1, 2], do:  {i, j}

pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>
for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}
```

# The :into option
```elixir
for <<c <- " hello world ">>, c != ?\s, into: "", do: <<c>>
for {key, val} <- %{"a" => 1, "b" => 2}, into: %{}, do: {key, val * val}

stream = IO.stream(:stdio, :line)
for line <- stream, into: stream do
  String.upcase(line) <> "\n"
end
```

# :reduce, :uniq 

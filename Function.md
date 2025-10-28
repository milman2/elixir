# Anonymous functions
```elixir
add = fn a, b -> a + b end
add.(1, 2)

is_function(add)
is_function(add, 2)
is_function(add, 1)
```
# Closures
```elixir
double = fn a -> add.(a, a) end
double.(2)

x = 42
(fn -> x = 0 end).()
x
```

# Cluases and guards
```elixir
f = fn
    x, y when x > 0 -> x + y
    x, y -> x * y
end
f.(1, 3)
f.(-1, 3)
```

# The capture operator
```elixir
fun = &is_atom/1
is_function(fun)
fun.(:hello)
fun.(123)

fun - &String.length/1
fun.("hello")

add = &+/2
add.(1, 2)

is_arity_2 = fn fun -> is_function(fun, 2) end
is_arity_2.(add)

is_arity_2 = &is_function(&1, 2)
is_arity_2.(add)

fun = &(&1 + 1)
fun.(1)

fun2 = &"Good #{&1}"
fun2.("morning")
```
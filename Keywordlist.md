# Keyword list
- data-structure used to pass options to functions
- lists consisting of 2-item tuples where the first element(the key) is an atom.
```elixir
String.split("1 2 3 4", [parts: 2])
String.split("1  2  3  4", [parts: 2, trim: true])
# When a keywordlist is the last argument of a function, we can skip the bracket
String.split("1  2  3  4", parts: 2, trim: true)
[{:parts, 3}, {:trim, true}] == [parts: 3, trim: true]
```
## characteristics
- Keys must be atoms
- Keys are ordered, as specified by the developer
- Keys can be given more than once.
```elixir
import String, only: [split: 1, split: 2]
```

## Access syntax
- list[:key]

## pattern matching
- number of items
- order ot match
```elixir
[a: a] = [a: 1]
[a: a] = [a: 1, b: 2] # MatchError
[b: b, a: a] = [a: 1, b: 2] # MatchError
```

## do-blocks and keywords
```elixir
if true do
    "This will be seen"
else
    "This won't"
end

if(true, do: "This will be seen", else: "This won't")
```

# Maps as key-value pairs
```elixir
map = %{:a => 1, 2 => :b}
map[:a]
map[2]
map[:c]
```
## pattern matching
- When a map is used in a pattern matching, it will always match on a subset of the given value
```elixir
%{} = %{:a => 1, 2 => :b} # an empty map matches all maps
%{:a => a} = %{:a => 1, 2 => :b}
%{:c => c} = %{:a => 1, 2 => :b} # MatchError
```
- Map.get
- Map.put
- Map.to_list

# Maps of predefined keys
```elixir
map = %{:name => "John", :age => 23}
map = %{name: "John", age: 23} # key: value syntax
map.name # When a key is an atom, we can access them using the map.key synatx

# updating
%{map | name: "Mary"}
%{map | agee: 27} # KeyError
```

# Nested data structures
- get_in/1
- put_in/2
- update_in/2 # allow us to pass a function
```elixir
users = [
  john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
  mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
]
users[:john].age
# updating
users = put_in(users[:john].age, 31)
users = update_in(users[:mary].languages, fn languages -> List.delete(languages, "Closure") end)
```
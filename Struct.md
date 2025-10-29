# Structs
- defstruct [list or keword list]
- Structs provide **compile-time** guarantees that only the fields defined through defstruct will be allowed to exist in a struct

```elixir
defmodule User do
    # defstruct name: "John", age: 27
    # defstruct [:email, name: "John", age: 27]
    defstruct [:email, :name, :age]
    # defstruct email: nil, name: "John", age: 27    
end

%User{}
%User{name: "Jane"}


``` 

## Accessing and updating structs
```elixir
john = %User{}
john.name

# update syntax(|)
jane = %{john | name: "Jane"}

# pattern matching
%User{name: name} = john
name

%User{} = %{} # MatchError
```

## Dynamic struct updates
- struct!/2
- 정의된 구조체 필드만 허용. 존재하지 않는 필드가 들어오면 런타임 오류 발생

```elixir
john = %User{name: "John", age: 27}
updates = [name: "Jane", age: 30]
struct!(john, updates)
```

## Structs are bare maps underneath
```elixir
is_map(john)
john.__struct__
```

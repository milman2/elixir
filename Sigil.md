# Sigil
- double-quoted string
- charlists ~c"hello world"

- Sigils start with the tilde (~) character which is followed by either a single lower-case letter or one or more upper-case letters, and then a delimiter. 
- Optional modifiers are added after the final delimiter.

## Regular expression
- -r
```elixir
regex = ~r/foo|bar/
"foo" =~ regex
"bat" =~ regex

"HELLO" =~ ~r/hello/
"HELLO" =~ ~r/hello/i
```

## 8 different delimiters
```elixir
~r/hello/
~r|hello|
~r"hello"
~r'hello'
~r(hello)
~r[hello]
~r{hello}
~r<hello>
```

## String
- ~s
## Charlist
- ~c
## Word list
- ~w
- modifier : c, s and a

## Interpolation and escaping in string sigils
- uppercase letters sigils do not perform interpolation nor escaping.

## heredoc
- double-quotes or single-quotes as separators

## Calendar sigil
### Date, Time
```elixir
# %Date{}
d = ~D[2019-10-31]

# %Time{}
t = ~T[23:00:07.0]

# %NaiveDateTime{}
ndt = ~N[2019-10-31 23:00:07]

# UTC DateTime %DateTime{}
dt = ~U[2019-10-31 19:59:03Z]
%DateTime{minute: minute, time_zone: time_zone} = dt
```

## Custom sigil
```elixir
sigil_r(<<"foo">>, [?i])

defmodule MySigils do
  def sigil_i(string, []), do: String.to_integer(string)
  def sigil_i(string, [?n]), do: -String.to_integer(string)
end
import MySigils

~i(13)
~i(42)n
```
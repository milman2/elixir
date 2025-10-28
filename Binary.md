# Unicode and Code Points
```elixir
?a
?ł

"\u0061" == "a"
0x0061 = 97 = ?a
```

# UTF-8 and Encodings
```elixir
string = "héllo"
String.length(string)
byte_size(string)

String.codepoints("👩‍🚒")
String.graphemes("👩‍🚒")
String.length("👩‍🚒")

"hełło" <> <<0>>
IO.inspect("hełło", binaries: :as_binaries)
```


# Bitstrings
```elixir
<<42>> == <<42::8>>
<<3::4>>
<<1>> == <<257>>
```

# Binaries
- A binary is a bitstring where the number of bits is divisible by 8.
- A string is a UTF-8 encoded binary.
```elixir
is_bitstring <<3::4>>
is_binary <<3::4>>
is_bitstring <<0, 255, 42>>
is_binary <<0, 255, 42>>
is_binary <<42::16>>

<<0, 1, x>> = <<0, 1, 2>>
<<0, 1, x::binary>> = <<0, 1, 2, 3>>
<<head::binary-size(2), rest::binary>> = <<0, 1, 2, 3>>

is_binary("hello")
is_binary(<<239, 191, 19>>)
String.valid?(<<239,191,19>>) # not every binary is a valid string

# binary concatenation operator
"a" <> "b"
<<0, 1>> <> <<2, 3>>
<<head, rest::binary>> = "banana"
"ü" <> <<0>>
<<x, rest::binary>> = "über" # x : first byte
<<x::utf8, rest::binary>> = "über" # x : first UTF-8 character
```

# Charlists
- A charlist is a list of integers where all the integers are valid code points.
```elixir
~c"hello"
[?h, ?e, ?l, ?l, ?o]
~c"hełło"
is_list(~c"hełło")

heartbeats_per_minute = [99, 97, 116]

to_charlist("hełło")
to_string(~c"hełło")
to_string(:hello)
to_string(1)

~c"this " ++ ~c"works"
"he" <> "llo"
```
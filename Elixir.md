# Elixir
- Erlang virtual machine (BEAM)

# install Elixir
- elixir-lang.org

```shell
curl -fsSO https://elixir-lang.org/install.sh
sh install.sh elixir@1.18.4 otp@27.3.4

# ~/.bashrc
export PATH=$HOME/.elixir-install/installs/otp/27.3.4/bin:$PATH
export PATH=$HOME/.elixir-install/installs/elixir/1.18.4-otp-27/bin:$PATH

erl -s erlang halt
elixir -v

# interactive mode
iex
```

# Example
```shell
mix new example
cd example

# 프로젝트 빌드 후 iex 실행
iex -S mix

# .beam 파일 생성
elixirc lib/hello.ex # Elixir.Hello.beam
iex> Example.hello
```

# [Elixir School](https://elixirschool.com/)
# Basic
## Basic Data Types
- Integer
- Float
- Boolean
- **Atom**
    - :name
- String

## Basic Operations
- Arithmetic
- Boolean
- Comparison
    - any two types can be compared
    - **number < atom < reference < function < port < pid < tuple < map < list < bitstring**
- String Interpolation
    - "... #{name} ..."
- String Concatenation:  <>

# Collection
- List (linked list) : []
    - multiple types
    - non-unique value
- List Concatenation : ++/2
- List Subtraction : --/2
    - the first occurrence of it gets removed from the left
    - strict comparision
- Head/Tail : hd/tl
    - pattern matching
    - **cons operator |**
- Tuple : {}
- **Keyword list**
    - Keys must be atoms.
    - Keys are ordered.
    - Keys do not have to be unique.
```elixir
[foo: "bar", hello: "world"]
[{:foo, "bar"}, {:hello, "world"}]
```    
- **Map : %{}**
    - keys of any type
    - un-ordered
```elixir
map = %{:foo => "bar", "hello" => :world}
map[:foo]
map["hello"]

%{foo: "bar", hello: "world"} == %{:foo => "bar", :hello => "world"}
# for atom key
map.foo
# update
%{map | foo: "baz"} 
# Map.put/3 키 존재 여부와 관계없이 안전하게 사용.
Map.put(map, :foo, "baz")
# Map.update/4
Map.update(map, :foo, "baz", fn _old -> "baz" end)
```

# Enum (enumerable)
```elixir
Enum.__info__(:functions) |> Enum.each(fn({function, arity})-> IO.puts "#{function}/#{arity}" end)
```
- all?
- any?
- chunk_every
- chunk_by
- map_every
- each
- map
- min
- max
- filter
- reduce
- sort
- uniq
- uniq_by
## Enum using the Capture operator (&)
```elixir
Enum.map([1,2,3], fn number -> number + 3 end)

Enum.map([1,2,3], &(&1 + 3))

plus_three = &(&1 + 3)
Enum.map([1,2,3], plus_three)

defmodule Adding do
  def plus_three(number), do: number + 3
end
Enum.map([1,2,3], fn number -> Adding.plus_three(number) end)
Enum.map([1,2,3], &Adding.plus_three(&1))
Enum.map([1,2,3], &Adding.plus_three/1)
```

# Pattern Matching
- **Match Operator : =**
- **Pin Operator : ^**
```elixir
greeting = "Hello"
greet = fn
    (^greeting, name) -> "Hi #{name}"
    (greeting, name) -> "#{greeting}, #{name}"
end
greet.("Hello", "Sean")
greet.("Mornin", "Sean")
greeting
```

# Control Structure
- if 
    - macro
    - only falsey values: nil, false
- case
    - _ (everything else)
    - guard clause
- cond
- with

```elixir
user = %{first: "Sean", last: "Callan"}
with {:ok, first} <- Map.fetch(user, :first),
     {:ok, last} <- Map.fetch(user, :last),
     do: last <> ", " <> first

user = %{first: "doomspork"}
with {:ok, first} <- Map.fetch(user, :first),
     {:ok, last} <- Map.fetch(user, :last), # error
     do: last <> ", " <> first

import Integer
m = %{a: 1, c: 3}
a =
  with {:ok, number} <- Map.fetch(m, :a),
    true <- is_even(number) do
      IO.puts "#{number} divided by 2 is #{div(number, 2)}"
      :even
  else
    :error ->
      IO.puts("We don't have this item in map")
      :error

    _ ->
      IO.puts("It is odd")
      :odd
  end
```

# Function
- first class citizen
- Anonymous Functions : fn <parameters> -> <body> end
- The & Shorthand
## Pattern Matching
```elixir
handle_result = fn
  {:ok, result} -> IO.puts "Handling result..."
  {:ok, _} -> IO.puts "This would be never run as previous will be matched beforehand."
  {:error} -> IO.puts "An error has occurred!"
end
some_result = 1
handle_result.({:ok, some_result})
handle_result.({:error})
```
- Named Functions
```elixir
defmodule Length do
  def of([]), do: 0
  def of([_ | tail]), do: 1 + of(tail)
end

Length.of []
Length.of [1, 2, 3]
```
- Function Naming and Arity
```elixir
defmodule Greeter2 do
  def hello(), do: "Hello, anonymous person!"   # hello/0
  def hello(name), do: "Hello, " <> name        # hello/1
  def hello(name1, name2), do: "Hello, #{name1} and #{name2}"
                                                # hello/2
end

Greeter2.hello()
Greeter2.hello("Fred")
Greeter2.hello("Fred", "Jane")
```
## Functions and Pattern Matching
```elixir
defmodule Greeter1 do
  def hello(%{name: person_name}) do
    IO.puts "Hello, " <> person_name
  end
end

fred = %{ name: "Fred", age: "95",favorite_color: "Taupe" }

Greeter1.hello(fred)

defmodule Greeter2 do
  def hello(%{name: person_name} = person) do
    IO.puts "Hello, " <> person_name
    IO.inspect person
  end
end

Greeter2.hello(fred)
Greeter2.hello(%{name: "Fred"})
Greeter2.hello(%{age: "95", favorite_color: "Taupe"})

defmodule Greeter3 do
  def hello(person = %{name: person_name}) do
    IO.puts "Hello, " <> person_name
    IO.inspect person
  end
end

Greeter3.hello(fred)
```

- Private Functions
```elixir
defmodule Greeter do
  def hello(name), do: phrase() <> name
  defp phrase, do: "Hello, "
end
```
- Guard
```elixir
defmodule Greeter do
  def hello(names) when is_list(names) do
    names = Enum.join(names, ", ")
    
    hello(names)
  end

  def hello(name) when is_binary(name) do
    phrase() <> name
  end

  defp phrase, do: "Hello, "
end

Greeter.hello ["Sean", "Steve"]
```
- Default Argument : arugment \\ value
```elixir
defmodule Greeter do
  def hello(name, language_code \\ "en") do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

Greeter.hello("Sean", "en")
Greeter.hello("Sean")
Greeter.hello("Sean", "es")

defmodule Greeter do
  def hello(names, language_code \\ "en")

  def hello(names, language_code) when is_list(names) do
    comma_separated_names = Enum.join(names, ", ")

    hello(comma_separated_names, language_code)
  end

  def hello(name, language_code) when is_binary(name) do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

Greeter.hello ["Sean", "Steve"]
Greeter.hello ["Sean", "Steve"], "es"
```
# Pipe Operator : |>

# Module
- Module Attributes
```elixir
defmodule Example do
  @greeting "Hello"

  def greeting(name) do
    ~s(#{@greeting} #{name}.)
  end
end
```
- reserved attributes : moduledoc, doc, behavior
## Struct
```elixir
defmodule Example.User do
  defstruct name: "Sean", roles: [] # keyword list of fields and default values
end

%Example.User{}
%Example.User{name: "Steve"}
%Example.User{name: "Steve", roles: [:manager]}
# update
steve = %Example.User{name: "Steve"}
sean = %{steve | name: "Sean"}

# match 
%{name: "Sean"} = sean
inspect(sean)

defmodule Example.User do
  @derive {Inspect, only: [:name]}
  # @derive {Inspect, except: [:roles]}
  defstruct name: nil, roles: []
end
```
## Composition
- alias
- import
    - filtering: :only, :except, :functions, :macros
- require
    - to use macro from another module
- use
    - to modify our current module's definition
```elixir
defmodule Hello do
  defmacro __using__(_opts) do
    quote do
      def hello(name), do: "Hi, #{name}"
    end
  end
end

defmodule Example do
  use Hello
end

Example.hello("Sean")

defmodule Hello do
  defmacro __using__(opts) do
    greeting = Keyword.get(opts, :greeting, "Hi")

    quote do
      def hello(name), do: unquote(greeting) <> ", " <> name
    end
  end
end

defmodule Example do
  use Hello, greeting: "Hola"
end

Example.hello("Sean")
```
- see. metaprogramming

# Mix
- New Project
    - mix.exs : configure application, dependencies, environment, and version
```shell
mix new <project-name>
mix compile
mix local.hex # install hex package manager
mix deps.get # install project dependencies

MIX_ENV=prod mix compile # Mix.env
```

# Sigil : ~<identifier><pair-of-delimiters>
~C Generates a character list with **no escaping or interpolation**
~c Generates a character list with **escaping and interpolation**
~R Generates a regular expression with no escaping or interpolation
~r Generates a regular expression with escaping and interpolation
~S Generates a string with no escaping or interpolation
~s Generates a string with escaping and interpolation
~W Generates a word list with no escaping or interpolation
~w Generates a word list with escaping and interpolation
~N Generates a NaiveDateTime struct
~U Generates a DateTime struct (since Elixir 1.9.0)

<...> A pair of pointy brackets
{...} A pair of curly brackets
[...] A pair of square brackets
(...) A pair of parentheses
|...| A pair of pipes
/.../ A pair of forward slashes
"..." A pair of double quotes
'...' A pair of single quotes

- Regular Expression
    - Perl Compatible Regular Expression (PCRE)
- String
- Word List
- NaiveDateTime
- DateTime
- Creating custom Sigil
```elixir
defmodule MySigils do
  def sigil_p(string, []), do: String.upcase(string)
end

import MySigils
~p/elixir school/
```
- Multi-character sigil : all characters must be uppercase

# Documentation
```
# - For inline documentation.
@moduledoc - For module-level documentation.
@doc - For function-level documentation
```
- Inline Documentation
- Documenting Module
```elixir
defmodule Greeter do
  @moduledoc """
  Provides a function `hello/1` to greet a human
  """

  def hello(name) do
    "Hello, " <> name
  end
end
```

```shell
iex> c("greeter.ex", ".")
iex> h Greeter

$ iex -S mix
```
- Documenting Function : @doc
    @spec
- ExDoc 

```shell
rm -rf deps
mix deps.get
mix docs
```
# Comprehension
- Generator
```elixir
# List
list = [1, 2, 3, 4, 5]
for x <- list, do: x*x

# Keyword List
for {_key, val} <- [one: 1, two: 2, three: 3], do: val

# Map
for {k, v} <- %{"a" => "A", "b" => "B"}, do: {k, v}

# Binary
for <<c <- "hello">>, do: <<c>>

# generators rely on pattern matching
for {:ok, val} <- [ok: "Hello", error: "Unknown", ok: "World"], do: val

# multiple generators
list = [1, 2, 3, 4]
for n <- list, times <- 1..n do
  String.duplicate("*", times)
end

for n <- list, times <- 1..n, do: IO.puts "#{n} - #{times}"
```
- Filters : guard for comprehension
```elixir
import Integer
for x <- 1..10, is_even(x), do: x

import Integer
for x <- 1..100,
  is_even(x),
  rem(x, 3) == 0, do: x
```
- Using :into 
    - Any structure that implements the **Collectable** protocol.
```elixir
for {k, v} <- [one: 1, two: 2, three: 3], into: %{}, do: {k, v}
for c <- [72, 101, 108, 108, 111], into: "", do: <<c>>
```

# String
- String : a sequence of bytes
```elixir
string = <<104,101,108,108,111>>
string <> <<0>>
```
- Charlist : **Unicode code point** of a character whereas in a binary, the codepoints are encodes as UTF-8.
```elixir
'hełło' # Unicode code point : 322
"hełło" <> <<0>> # UTF-* : 197, 130
?Z # get a character’s code point by using ?
```
- Grapheme and Codepoint
```elixir
string = "\u0061\u0301"
String.codepoints string
String.graphemes string
```

# Date and Time
```elixir
Time.utc_now
t = ~T[19:39:31.056226]
t.hour
t.minute

Date.utc_now
{:ok, date} = Date.new(2020, 12, 12)
Date.day_of_week date
Date.leap_year? date

NaiveDateTime.utc_now
NaiveDateTime.add(~N[2018-10-01 00:00:14], 30)

DateTime.from_naive(~N[2016-05-24 13:26:08.003], "Etc/UTC")

# tzdata package
# config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
paris_datetime = DateTime.from_naive!(~N[2019-01-01 12:00:00], "Europe/Paris")
{:ok, ny_datetime} = DateTime.shift_zone(paris_datetime, "America/New_York")

```
# IEX Helper

# Error Handling
- raise/try/rescue/after
```elixir
try do
    raise "Oh no!"
    raise ArgumentError, message: "the argument value is invliad"
rescue
    e in RuntimeError -> IO.puts("An error occurred:" <> e.message)
after
    IO.puts "The end!"
end
```

```elixir
defmodule ExampleError do
  defexception message: "an example error has occurred"
end

try do
  raise ExampleError
rescue
  e in ExampleError -> e
end
```

- throw/catch
```elixir
try do
  for x <- 0..10 do
    if x == 5, do: throw(x)
    IO.puts(x)
  end
catch
  x -> "Caught: #{x}"
end
```

- exit
```elixir
try do
  exit "oh no!"
catch
  :exit, _ -> "exit blocked"
end
```

# Process
- spawn
- send
- receive

- GenServer.call/2 -> handle_call/3 # 동기 처리
- GenServer.cast/2 -> handle_cast/2 # 비동기 처리
- send/2 -> handle_info/2           # 비동기 처리. 예상치 못한 메시지나 외부 메시지 처리

```elixir
spawn(fn -> 
  Process.sleep(3_000)
  IO.puts("order processed!") 
end)

v(1) # IEx 에서 n번째 결과를 다시 불러오는 함수

Process.alive?(v(1))

Process.info(self())
flush
```
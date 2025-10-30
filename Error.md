# try, catch and rescue
- error(or exception), throw, exit

## raise
```elixir
raise "oops"
raise ArgumentError, message: "invalid argument foo"

defmodule MyError do
    defexception message: "default message"
end

raise MyError
raise MyError, message: "custom message"

try do
    raise "oops"
rescue
    e in RuntimeError -> e
end

case File.read("hello") do
  {:ok, body} -> IO.puts("Success: #{body}")
  {:error, reason} -> IO.puts("Error: #{reason}")
end
```

## Fail fase / Let it crash

## reraise
```elixir
try do
  ... some code ...
rescue
  e ->
    Logger.error(Exception.format(:error, e, __STACKTRACE__))
    reraise e, __STACKTRACE__
end
```

## throw

## exit
```elixir
try do
  exit("I am exiting")
catch
  :exit, _ -> "not really"
end

defmodule Example do
  def matched_catch do
    exit(:timeout)
  catch
    :exit, :timeout ->
      {:error, :timeout}
  end

  def mismatched_catch do
    exit(:timeout)
  catch
    # Since no clause matches, this catch will have no effect
    :exit, :explosion ->
      {:error, :explosion}
  end
end
```

## after
```elixir
{:ok, file} = File.open("sample", [:utf8, :write])
try do
  IO.write(file, "olá")
  raise "oops, something went wrong"
after
  File.close(file)
end

defmodule RunAfter do
  def without_even_trying do
    raise "oops"
  after
    IO.puts("cleaning up!")
  end
end
RunAfter.without_even_trying
```

## else
```elixir
x = 2

try do
  1 / x
rescue
  ArithmeticError ->
    :infinity
else
  y when y < 1 and y > -1 ->
    :small
  _ ->
    :large
end
```

## Variables scope
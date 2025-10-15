defmodule Unless do
  # the arguments to a function call are evaluated before calling the function.
  def fun_unless(clause, do: expression) do
    if(!clause, do: expression)
  end

  # receive the arguments as quoted expressions
  defmacro macro_unless(clause, do: expression) do
    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end
end


# iex macros.exs
# require Unless
# Unless.macro_unless(true, do: IO.puts("this should never be printed"))
# Unless.fun_unless(true, do: IO.puts("this should never be printed"))

# expr = quote do: Unless.macro_unless(true, do: IO.puts("this should never be printed"))
# res = Macro.expand_once(expr, __ENV__)
# IO.puts(Macro.to_string(res))


defmodule Hygiene do
  defmacro interference do
    quote do: var!(a) = 1
  end
end

defmodule HygieneTest do
  def go do
    require Hygiene
    a = 13
    Hygiene.interference()
    a
  end
end

# HygieneTest.go()


defmodule Sample do
  defmacro initialize_to_char_count(variables) do
    Enum.map(variables, fn name ->
      var = Macro.var(name, nil)
      length = name |> Atom.to_string() |> String.length()

      quote do
        unquote(var) = unquote(length)
      end
    end)
  end

  def run do
    initialize_to_char_count([:red, :green, :yellow])
    [red, green, yellow]
  end
end

# Sample.run()

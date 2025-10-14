defmodule CounterApp do
  def run do
    Counter.start_link(0)
    Counter.inc(5)
    IO.puts("Current count: #{Counter.get()}")
  end
end

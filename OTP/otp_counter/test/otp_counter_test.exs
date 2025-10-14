defmodule OtpCounterTest do
  use ExUnit.Case
  doctest OtpCounter

  test "greets the world" do
    assert OtpCounter.hello() == :world
  end
end

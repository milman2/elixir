defmodule Counter do
  use GenServer

  # Client API
  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def get(), do: GenServer.call(__MODULE__, :get)
  def inc(n), do: GenServer.cast(__MODULE__, {:inc, n})

  # Server Callbacks
  def init(value), do: {:ok, value}

  def handle_call(:get, _from, state), do: {:reply, state, state}
  def handle_cast({:inc, n}, state), do: {:noreply, state + n}
end

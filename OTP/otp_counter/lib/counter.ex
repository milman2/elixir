defmodule OtpCounter.Counter do
  use GenServer

  # Client API
  def start_link(_args) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def get(), do: GenServer.call(__MODULE__, :get)
  def inc(), do: GenServer.cast(__MODULE__, :inc)
  def crash(), do: GenServer.call(__MODULE__, :crash)

  # Server Callbacks
  def init(state), do: {:ok, state}

  def handle_call(:get, _from, state), do: {:reply, state, state}
  def handle_call(:crash, _from, _state), do: exit(:boom)
  def handle_cast(:inc, state), do: {:noreply, state + 1}
end

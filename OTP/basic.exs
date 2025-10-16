defmodule Typical do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(initial_state) do
    #IO.puts "I am in the init method"
    #IO.inspect initial_state
    {:ok, initial_state}
  end

  # Callbacks
  # def handle_call({:some_call}, _from, state) do
  #   #IO.puts "I handle GenServer calls"
  #   #IO.inspect state
  #   {:reply, state, state}
  # end

  # def handle_cast({:some_cast}, state) do
  #   # IO.puts "I handle GenServer casts"
  #   {:noreply, state}
  # end

  # def handle_info({:some_info}, state) do
  #   # IO.puts "I handle messages from other places"
  #   {:noreply, state}
  # end

  # synchronous callback
  def handle_call({:get_count}, _from, state) do
    current_count = Map.get(state, :count)
    {:reply, current_count, state}
  end

  def handle_call({:set_count, new_count}, _from, state) do
    new_state = Map.put(state, :count, new_count)
    {:reply, new_state, new_state}
  end

  #


  def get_count(pid) do
    GenServer.call(pid, {:get_count})
  end

  def set_count(pid, count) do
    GenServer.call(pid, {:set_count, count})
  end


  def run do
    {:ok, pid} = Typical.start_link(%{count: 0})
    IO.puts Typical.get_count(pid)
    IO.inspect Typical.set_count(pid, 10)
    IO.puts Typical.get_count(pid)
  end
end

Typical.run()

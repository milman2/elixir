# pid = spawn(fn -> 1 + 2 end)
# Process.alive?(self())
# send(self(), {:hello, "world"})
# receive do
#   {:hello, msg} -> IO.puts("Received: #{message}")
# after
#   1_000 -> "nothing after 1s"
# end
# flash()

# spawn(fn -> raise "oops!" end)
# spawn_link(fn -> raise "oops!" end)

# Task.start(fn -> raise "oops!" end)
# Task.start_link(fn -> raise "oops!" end)
# task = Task.async(fn -> 1 + 2 end)
# Task.await(task)

# State
defmodule KV do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send(caller, Map.get(map, key))
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end


# {:ok, pid} = KV.start_link()
# send(pid, {:get, :hello, self()})
# flush()

# send(pid, {:put, :hello, :world})
# send(pid, {:get, :hello, self()})
# flush()

# Process.register(pid, :kv)
# send(:kv, {:get, :hello, self()})
# flush()
# Process.unregister(:kv)

# Agent
# {:ok, pid} = Agent.start_link(fn -> %{} end)
# Agent.update(pid, fn map -> Map.put(map, :hello, :world) end)
# Agent.get(pid, fn map -> Map.get(map, :hello) end)
# Agent.stop(pid)

# Registry
# {:ok, pid} = Registry.start_link(keys: :unique, name: :kv)
# Registry.register(:kv, "shopping", ["bananas", "eggs"])
# Registry.lookup(:kv, "shopping")
# Process.exit(pid, :shutdown)

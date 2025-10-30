# Process
## Spawning process
- spawn
- PID (proces identifier)

```elixir
spawn(fn -> 1 + 2 end)
```

## Sending and receiving message
- send
- receive
- process mailbox
- flush
```elixir
parent = self()
spawn(fn -> send(parent, {:hello, self()}) end)
receive do
  {:hello, pid} -> "Got hello from #{inspect pid}"
end
```

## Link
- spawn_link
- Process.link

## Task
- Task.start
- Task.start_link
- Task.async
- Task.await

## State
- Process.register
- Agent.start_link
- Agent.update
- Agent.get
- GenServer
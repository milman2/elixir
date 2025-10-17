# OTP (Open Telecom Platform)
- Supervisor
- GenServer
- Application
- Task
- Registry
- DynamicSupervisor

```shell
mix new counter_app
cd counter_app

iex -S mix
```

```shell
mix new otp_counter --sup
cd otp_counter

iex -S mix
OtpCounter.Counter.get()     # => 0
OtpCounter.Counter.inc()
OtpCounter.Counter.get()     # => 1

OtpCounter.Counter.crash()   # 강제 종료

# 자동으로 Supervisor가 재시작
OtpCounter.Counter.get()     # => 0 (초기화됨)
```

## ETS(Elang Term Storage)
## Agent
## GenServer
## Task
```elixir
{:ok, agent} = Agent.start_link(fn -> [] end)
Agent.update(agent, fn list -> ["eggs" | list] end)
Agent.get(agent, fn list -> list end)
Agent.stop(agent)

{:ok, agent} = Agent.start_link(fn -> [] end)
Agent.update(agent, fn _list -> 123 end)
Agent.update(agent, fn content -> %{a: content} end)
Agent.update(agent, fn content -> [12 | [content]] end)
Agent.update(agent, fn list -> [:nop | list] end)
Agent.get(agent, fn content -> content end)
```
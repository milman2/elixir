# Agent.start_link(fn -> initial_value end, name: __MODULE__)
# Agent.get(agent, fn state -> ... end)
# Agent.update(agent, fn state -> new_state end)
# Agent.stop(agent)

# 상태를 읽고 쓰는 함수만 정의하면 되며, 복잡한 콜백이나 메시지 패턴이 필요 없음
# 단순한 상태 저장에 최적화
defmodule AgentExample do
  use Agent

  def start_link do
    IO.puts "AgentExample is starting"
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add(item_id) do
    Agent.update(__MODULE__, fn state ->
      Map.update(state, item_id, 1, & (&1 + 1))
    end)
  end

  def remove(item_id) do
    Agent.update(__MODULE__, fn state ->
      Map.update(state, item_id, 1, & (&1 - 1))
    end)
  end

  def get_count(item_id) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state, item_id, 0)
    end)
  end
end

# AgentExample.start_link()
# AgentExample.add(:apple)
# AgentExample.add(:banana)
# AgentExample.remove(:apple)
# AgentExample.get_count(:apple)
# AgentExample.get_count(:banana)

# ETS (Erlang Term Storage)
- in-memory key-value storage
## Table
- set
- ordered_set
- bag
- duplicate_bag

- public
- protected
- private


```elixir
table = :ets.new(:user_lookup, [:set, :protected]) # 익명 테이블
:ets.new(:user_lookup, [:set, :protected, :named_table])
:ets.insert(:user_lookup, {"doomspork", "Sean", ["Elixir", "Ruby", "Java"]}) # {key, value1, value2, ..., valueN}
:ets.insert_new(:user_lookup, {"doomspork", "Sean", ["Elixir", "Ruby", "Java"]})
:ets.insert_new(:user_lookup, {"3100", "", ["Elixir", "Ruby", "JavaScript"]})

:ets.lookup(:user_lookup, "doomspork")
```

## matching
- :"$1", :"$2", :"$3" 숫자는 결과의 위치
- _
- :"$$", :"$_"
```elixir
:ets.match(:user_lookup, {:"$1", "Sean", :_})
:ets.match_object(:user_lookup, {:"$1", :_, :"$3"})
:ets.match_object(:user_lookup, {:_, "Sean", :_})

:ets.select(:user_lookup, [{{:"$1", :_, :"$3"}, [], [:"$_"]}]) # {매칭할 tuple 구조, 가드 조건, 결과}

# matching spec
fun = :ets.fun2ms(fn {username, _, langs} when length(langs) > 2 -> username end)
:ets.select(:user_lookup, fun)
```

```elixir
:ets.delete(:user_lookup, "doomspork")
:ets.delete(:user_lookup)
```

## Example
- key: [mod, fun, args]
```elixir
defmodule SimpleCache do
  @moduledoc """
  비용이 비싼 함수 호출을 위한 단순한 ETS 기반 캐시
  """

  @doc """
  캐시된 값을 검색하거나, 주어진 함수를 캐시해서 값을 반환합니다.
  """
  def get(mod, fun, args, opts \\ []) do
    case lookup(mod, fun, args) do
      nil ->
        ttl = Keyword.get(opts, :ttl, 3600)
        cache_apply(mod, fun, args, ttl)

      result ->
        result
    end
  end

  @doc """
  캐시된 결과를 검색하여, 유효한지 확인합니다.
  """
  defp lookup(mod, fun, args) do
    case :ets.lookup(:simple_cache, [mod, fun, args]) do
      [result | _] -> check_freshness(result)
      [] -> nil
    end
  end

  @doc """
  결과의 유효기간을 현재 시스템의 시간과 비교합니다.
  """
  defp check_freshness({mfa, result, expiration}) do
    cond do
      expiration > :os.system_time(:seconds) -> result
      :else -> nil
    end
  end

  @doc """
  함수를 추가하고, 유효기간을 설정하고, 결과를 캐시합니다.
  """
  defp cache_apply(mod, fun, args, ttl) do
    result = apply(mod, fun, args)
    expiration = :os.system_time(:seconds) + ttl
    :ets.insert(:simple_cache, {[mod, fun, args], result, expiration})
    result
  end
end

defmodule ExampleApp do
  def test do
    :os.system_time(:seconds)
  end
end

:ets.new(:simple_cache, [:named_table])

ExampleApp.test
SimpleCache.get(ExampleApp, :test, [], ttl: 10)
ExampleApp.test
SimpleCache.get(ExampleApp, :test, [], ttl: 10)
```

## DBTS (Disk Based Term Storage)
```elixir
{:ok, table} = :dets.open_file(:disk_storage, [type: :set])
:dets.insert_new(table, {"doomspork", "Sean", ["Elixir", "Ruby", "Java"]})
select_all = :ets.fun2ms(&(&1))
:dets.select(table, select_all)
```



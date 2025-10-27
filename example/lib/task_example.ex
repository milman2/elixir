# Task : 주로 단발성, 비동기 작업 처리에 적합. cf. GenServer: 상태 유지하며 지속적인 상호작용이 필요한 서버 프로세스 구현
# Task.async(fn -> ... end) : 비동기 작업을 시작하고 결과를 반환하는 Task 프로세스를 생성. 결과가 반드시 필요할 때.
# Task.await(task) : 비동기 작업의 결과를 기다림. 기본 타입아웃 5000ms. 타임아웃시 exit 예와 발생
# Task.yield(task) :

# Task.start(fn -> ... end) : 비동기 작업을 시작하고 결과를 반환하지 않음.
# Task.start_link(fn -> ... end) : 부모 프로세스와 연결된 Task 프로세스를 생성.

# Task.async_stream(collection, fn -> ... end, options)
# Task.async_stream_nolimited(collection, fn -> ... end, options)
# Task.async_stream_limited(collection, fn -> ... end, options)
# Task.async_stream_nolimited(collection, fn -> ... end, options)

defmodule TaskExample do
  def run do
    task = Task.async(fn -> 1 + 2 end)
    result = Task.await(task, 3000)
    IO.puts("Result: #{result}")

    task = Task.async(fn -> :timer.sleep(1000); "don" end)
    case Task.yield(task, 500) || Task.shutdown(task) do
      {:ok, result} -> IO.puts("Result: #{result}")
      nil -> IO.puts("Task timed out")
    end
  end
end

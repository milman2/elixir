defmodule BasicSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    # restart options: :permanent, :transient, :temporary
    children = [
      {BasicOne, []},
      {BasicTwo, []},
      {BasicThree, []},
      {BasicFour, []},
    ]

    # :one_for_one
    # :one_for_all
    # :rest_for_one
    # :simple_one_for_one
    Supervisor.init(children, strategy: :one_for_one)
    # supervise(children, strategy: :one_for_one) # deprecated
  end
end

defmodule BasicOne do
  use GenServer

  def start_link(_args) do
    IO.puts "BasicOne is starting"
    GenServer.start_link(__MODULE__, [])
  end

  def init(initial_state) do
    {:ok, initial_state}
  end

end

defmodule BasicTwo do
  use GenServer

  def start_link(_args) do
    IO.puts "BasicTwo is starting"
    GenServer.start_link(__MODULE__, [])
  end

  def init(initial_state) do
    {:ok, initial_state}
  end
end

defmodule BasicThree do
  use GenServer

  def start_link(_args) do
    IO.puts "BasicThree is starting"
    GenServer.start_link(__MODULE__, [])
  end

  def init(initial_state) do
    {:ok, initial_state}
  end
end

defmodule BasicFour do
  use GenServer

  def start_link(_args) do
    IO.puts "BasicFour is starting"
    GenServer.start_link(__MODULE__, [])
  end

  def init(initial_state) do
    {:ok, initial_state}
  end
end


{:ok, supervisor_pid} = BasicSupervisor.start_link()

# IEx에서 사용할 수 있도록 변수 출력
IO.inspect(supervisor_pid, label: "Supervisor PID")

Process.alive?(supervisor_pid)
[four, three, two, one] = Supervisor.which_children(supervisor_pid)
{_, one_pid, _, _} = one
GenServer.stop(one_pid)
Process.alive?(one_pid)

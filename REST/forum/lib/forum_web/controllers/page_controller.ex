defmodule ForumWeb.PageController do
  use ForumWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def users(conn, _params) do
    IO.puts "Users function called"
    # mocking data
    users = [
      %{id: 1, name: "John", email: "john@example.com"},
      %{id: 2, name: "Jane", email: "jane@example.com"},
      %{id: 3, name: "Jim", email: "jim@example.com"},
    ]
    # render(conn, :users, users: users)
    json(conn, %{users: users})
  end
end

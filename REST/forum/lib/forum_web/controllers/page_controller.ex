defmodule ForumWeb.PageController do
  use ForumWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

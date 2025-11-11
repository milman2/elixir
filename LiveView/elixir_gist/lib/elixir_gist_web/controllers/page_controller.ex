defmodule ElixirGistWeb.PageController do
  use ElixirGistWeb, :controller

  def home(conn, _params) do
    render(conn, :home) # home.html.heex를 렌더링
  end
end

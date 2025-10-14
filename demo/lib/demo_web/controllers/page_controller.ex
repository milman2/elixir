defmodule DemoWeb.PageController do
  use DemoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def hello(conn, _params) do
    render(conn, :hello)
  end
end

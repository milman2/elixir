defmodule DemoWeb.ExampleController do
  use DemoWeb, :controller

  def hello(conn, _params) do
    render(conn, :hello)
  end
end

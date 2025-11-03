defmodule ShopWeb.RandomController do
  use ShopWeb, :controller

  def random(conn, _params) do
    render(conn, :random)
  end
end

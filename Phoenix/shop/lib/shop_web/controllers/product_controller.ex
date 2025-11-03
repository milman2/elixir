defmodule ShopWeb.ProductController do
  use ShopWeb, :controller

  def index(conn, _params) do
    #dbg(conn)
    #dbg(params)
    render(conn, :index)
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, id: id, name: "X-box")
  end

end

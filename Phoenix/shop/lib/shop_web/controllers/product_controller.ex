defmodule ShopWeb.ProductController do
  use ShopWeb, :controller

  @products [
    %{id: 1, name: "God of war", price: 100},
    %{id: 2, name: "Skyrim", price: 200},
    %{id: 3, name: "Diablo", price: 300}
  ]

  def index(conn, _params) do
    #dbg(conn)
    #dbg(params)
    conn
    |> assign(:products, @products)
    |> render(:index)
  end

  def show(conn, %{"id" => id}) do
    product = Enum.find(@products, fn product -> product.id == String.to_integer(id) end)
    conn
    |> assign(:product, product)
    |> render(:show)
  end

  def random(conn, parans) do
    #text(conn, "This si some text")
    #html(conn, "<html><body><h1>This is a random product</h1></body></html>")
    #json(conn, %{message: "This is a random product"})
    render(conn, :random)
  end
end

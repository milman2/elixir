defmodule ShopWeb.ProductController do
  use ShopWeb, :controller


  alias Shop.{Repo, Product}

  def index(conn, _params) do
    # dbg(conn)
    # dbg(params)
    products = Repo.all(Product)

    conn
    |> assign(:products, products)
    |> render(:index)
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get(Product, id)

    conn
    |> assign(:product, product)
    |> render(:show)
  end

  def random(conn, params) do
    # text(conn, "This si some text")
    # html(conn, "<html><body><h1>This is a random product</h1></body></html>")
    # json(conn, %{message: "This is a random product"})
    render(conn, :random)
  end
end

defmodule ShopWeb.ApiJSON do
  alias Shop.Products.Product

  def index(%{products: products}) do
    %{products: products}
  end
end

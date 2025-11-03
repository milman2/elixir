defmodule ShopWeb.ProductHTML do
  alias Shop.Product
  use ShopWeb, :html

  # def index(assigns) do
  #   ~H"""
  #   <div>
  #     <h1>Products</h1>
  #   </div>
  #   """
  # end

  embed_templates "product_html/*"

  attr :product, Product, required: true
  def product(assigns) do
    ~H"""
    <.link href={~p"/products/#{@product.slug}"} class="block">{@product.name}</.link>
    """
  end
end

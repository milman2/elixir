defmodule ShopWeb.ProductHTML do
  use ShopWeb, :html

  # def index(assigns) do
  #   ~H"""
  #   <div>
  #     <h1>Products</h1>
  #   </div>
  #   """
  # end

  embed_templates "product_html/*"

  attr :name, :string, required: true

  def product(assigns) do
    ~H"""
    <p>Game: {@name}</p>
    """
  end
end

defmodule ShopWeb.ProductJSON do
  alias Shop.Products.Product

  # def index(_assigns) do
  #   %{
  #     data: [
  #       %{name: "God of war"},
  #       %{name: "Skyrim"},
  #       %{name: "Diablo"},
  #     ]
  #   }
  # end

  def index(%{products: products}) do
    %{
      data: products
    }
  end


end

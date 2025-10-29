defmodule DiscountExt do
  #defmacro extend do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      def apply_discounts(product) do
        case product do
          product when product.price > 100 -> Map.update!(product, :price, &(&1 * 0.9))
          _ -> product
        end
      end
    end
  end
end

defmodule Product do
  #require DiscountExt
  #DiscountExt.extend()
  use DiscountExt
end

# c "discount_ext.exs"
# product = %{name: "Leather Handbag", category: "Accessories", price: 120}
# Product.apply_discounts product

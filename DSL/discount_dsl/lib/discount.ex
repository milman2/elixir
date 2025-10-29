defmodule Discount do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :discounts, accumulate: true)

      @before_compile unquote(__MODULE__)
      # def apply_discounts do
      #   IO.puts("Applying thes discounts #{inspect @discounts}")
      # end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def apply_discounts(product) do
        # IO.puts("Applying thes discounts #{inspect @discounts}")
        Enum.reduce(@discounts, product, fn discount, product ->
          apply_discount_rule(product, discount)
        end)

      end

      defp apply_discount_rule(product, {_name, required_fields, condition, action}) do
        case validate_and_apply(product, required_fields, condition) do
          :apply -> apply(__MODULE__, action, [product])
          :skip -> product
        end
      end

      # fallback option
      defp apply_discount_rule(product, _) do
        product
      end

      defp validate_and_apply(product, required_fields, condition) do
        if validate_product(product, required_fields) and apply(__MODULE__, condition, [product]) do
          :apply
        else
          :skip
        end
      end

      defp validate_product(product, required_fields) do
        Enum.all?(required_fields, &Map.has_key?(product, &1))
      end
    end
  end

  defmacro discount(name, required_fields, condition, action) do
    # quote do
    #   @discounts {unquote(name), unquote(condition), unquote(action)}
    # end
    quote bind_quoted: [name: name, required_fields: required_fields, condition: condition, action: action] do
      @discounts {name, required_fields, condition, action}
    end
  end
end

defmodule Discounts do
  use Discount

  # 매크로 사용 예제
  discount :over_100, [:price], :is_over_100?, :apply_10_percent_discount

  def is_over_100?(product) do
    product.price > 100
  end

  def apply_10_percent_discount(product) do
    Map.update!(product, :price, &(&1 * 0.9))
  end

  discount :electronics, [:price, :category], :is_electronics?, :apply_5_percent_discount

  def is_electronics?(product) do
    product.category == :electronics
  end

  def apply_5_percent_discount(product) do
    Map.update!(product, :price, &(&1 * 0.95))
  end

  discount :free_shipping, [:price], :is_eligible_for_free_shipping?, :apply_free_shipping

  def is_eligible_for_free_shipping?(product) do
    product.price > 50
  end

  def apply_free_shipping(product) do
    Map.put(product, :free_shipping, true)
  end
end

# c "discount.exs"
# Discounts.__info__(:functions)
# product = %{name: "Leather Handbag", category: :accessories, price: 120}
# product2 = %{name: "Wireless Headphone", category: :electronics, price: 80}
# Discounts.apply_discounts(product)
# Discounts.apply_discounts(product2)

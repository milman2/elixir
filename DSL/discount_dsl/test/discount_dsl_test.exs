defmodule DiscountDslTest do
  use ExUnit.Case

  test "Ensure the Module Loads" do
    assert Code.ensure_loaded?(DiscountDsl)
  end

  #1. Apply a discount to a product if the condition met.
  test "single discount is applied correctly" do
    product = %{category: :toy, price: 60}
    discounted_product = Discounts.apply_discounts(product)
    assert discounted_product.free_shipping == true
    assert discounted_product.price == 60
    assert discounted_product.category == :toy
  end

  #2. Apply multiple discounts in sequence if multiple discounts are met
  test "multiple discounts are applied in order" do
    product = %{category: :electronics, price: 200}
    discounted_product = Discounts.apply_discounts(product)
    assert discounted_product.free_shipping == true
    assert discounted_product.price == 171.0
    assert discounted_product.category == :electronics
  end

  #3. Ensure discounts are not applied if conditions are not met.
  test "discounts are not applied if conditions are not met" do
    product = %{category: :toy, price: 40}
    discounted_product = Discounts.apply_discounts(product)
    assert discounted_product == product
  end

  #4. Handle edge case, if a product is $100
  test "checking edge case to make sure no discount is applied if product is %100" do
    product = %{category: :toy, price: 100}
    discounted_product = Discounts.apply_discounts(product)
    assert discounted_product.free_shipping == true
    assert discounted_product.price == 100.0
    assert discounted_product.category == :toy
  end

  #5. Invalid input are handled gracefully.
  test "invalid product: missing price" do
    product = %{category: :toy}
    discounted_product = Discounts.apply_discounts(product)
    assert discounted_product == product
  end
end

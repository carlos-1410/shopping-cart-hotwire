# frozen_string_literal: true

require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  def setup
    @cart = Cart.create!
    @product = Product.create!(name: "Test Product", vendor: "Test Vendor", price: 1500)
    @cart_item = CartItem.new(cart: @cart, product: @product, quantity: 2, total_price: 3000)
  end

  test "is valid with all attributes" do
    assert @cart_item.valid?
  end

  test "is invalid without a cart" do
    @cart_item.cart = nil
    assert_not @cart_item.valid?
  end

  test "is invalid without a product" do
    @cart_item.product = nil
    assert_not @cart_item.valid?
  end

  test "is invalid without a quantity" do
    @cart_item.quantity = nil
    assert_not @cart_item.valid?
  end

  test "is invalid with zero or negative quantity" do
    @cart_item.quantity = 0
    assert_not @cart_item.valid?

    @cart_item.quantity = -1
    assert_not @cart_item.valid?
  end

  test "is invalid without a total_price" do
    @cart_item.total_price = nil
    assert_not @cart_item.valid?
  end
end

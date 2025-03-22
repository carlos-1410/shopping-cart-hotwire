# frozen_string_literal: true

require "test_helper"

class CartTest < ActiveSupport::TestCase
  def setup
    @cart = Cart.create!
  end

  test "cart is valid" do
    assert @cart.valid?
  end

  test "cart has many cart_items" do
    assert_respond_to @cart, :cart_items
  end

  test "cart has many products through cart_items" do
    assert_respond_to @cart, :products
  end

  test "deleting a cart deletes its cart_items" do
    product = Product.create!(name: "Test Product", vendor: "Vendor", price: 1500)
    @cart.cart_items.create!(product: product, quantity: 1, total_price: 1500)

    assert_difference -> { CartItem.count }, -1 do
      @cart.destroy
    end
  end
end

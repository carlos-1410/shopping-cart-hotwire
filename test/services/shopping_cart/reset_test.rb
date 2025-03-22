# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  class ResetTest < ActiveSupport::TestCase
    def setup
      @cart = Cart.create!
      @product = Product.create!(vendor: "Vendor", name: "Test Product", price: 100)
      @cart_item = @cart.cart_items.create!(product: @product, quantity: 1,
                                            total_price: @product.price)
    end

    test "successfully resets the cart when it exists" do
      assert_difference("@cart.cart_items.count", -1) do
        response = ShoppingCart::Reset.new(cart: @cart).call
        assert response.success?
      end
    end

    test "fails when the cart does not exist" do
      response = ShoppingCart::Reset.new(cart: nil).call
      assert_not response.success?
      assert_equal "Your cart was not created, please reload the page.", response.value
    end
  end
end

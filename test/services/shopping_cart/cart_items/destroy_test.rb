# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  module CartItems
    class DestroyTest < ActiveSupport::TestCase
      def setup
        @cart = Cart.create!
        @product = Product.create!(vendor: "Vendor", name: "Test Product", price: 1050)
        @cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 2,
                                      total_price: @product.price * 2)
      end

      test "removes the cart item if it exists" do
        service = ShoppingCart::CartItems::Destroy.new(cart: @cart, cart_item_id: @cart_item.id)
        response = service.call

        assert response.success?, "Expected a successful response"
        assert_not CartItem.exists?(@cart_item.id), "Cart item was not deleted"
      end

      test "returns failure if cart item does not exist" do
        invalid_cart_item_id = -1

        service = ShoppingCart::CartItems::Destroy.new(cart: @cart,
                                                       cart_item_id: invalid_cart_item_id)
        response = service.call

        assert_not response.success?, "Expected failure response"
        assert_equal "Product was not found in the cart.", response.value,
                     "Did not return correct error message"
      end
    end
  end
end

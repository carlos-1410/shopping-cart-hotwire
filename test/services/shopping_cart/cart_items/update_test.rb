# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  module CartItems
    class UpdateTest < ActiveSupport::TestCase
      def setup
        @cart = Cart.create!
        @product = Product.create!(vendor: "Vendor", name: "Test Product", price: 1050)
        @cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 1,
                                      total_price: @product.price)
      end

      test "updates cart item with new quantity and recalculates total price" do
        new_quantity = 3
        expected_total_price = (@product.price * new_quantity).ceil(2)

        service = ShoppingCart::CartItems::Update.new(cart: @cart, cart_item: @cart_item,
                                                      quantity: new_quantity)
        response = service.call

        @cart_item.reload

        assert response.success?
        assert_equal new_quantity, @cart_item.quantity
        assert_equal expected_total_price, @cart_item.total_price
      end

      test "removes cart item when quantity is zero or negative" do
        service = ShoppingCart::CartItems::Update.new(cart: @cart, cart_item: @cart_item,
                                                      quantity: 0)
        response = service.call

        assert response.success?
        assert_not CartItem.exists?(@cart_item.id)
      end
    end
  end
end

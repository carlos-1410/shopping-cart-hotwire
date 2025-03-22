# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  module CartItems
    class CreateTest < ActiveSupport::TestCase
      def setup
        @cart = Cart.create!
        @product = Product.create!(vendor: "Vendor", name: "Test Product", price: 1050)
      end

      test "creates a new cart item with valid inputs" do
        quantity = 3
        expected_total_price = (@product.price * quantity).ceil(2)

        service = ShoppingCart::CartItems::Create.new(cart: @cart, product_id: @product.id,
                                                      quantity: quantity)
        response = service.call

        cart_item = @cart.cart_items.find_by(product_id: @product.id)

        assert response.success?
        assert_not_nil cart_item
        assert_equal quantity, cart_item.quantity
        assert_equal expected_total_price, cart_item.total_price
      end

      test "fails to create cart item if quantity is zero or negative" do
        service = ShoppingCart::CartItems::Create.new(cart: @cart, product_id: @product.id,
                                                      quantity: 0)
        response = service.call

        assert_not response.success?
        assert_match(/Quantity must be greater than 0/, response.value)
        assert_nil @cart.cart_items.find_by(product_id: @product.id)
      end

      test "fails if product does not exist" do
        invalid_product_id = -1
        service = ShoppingCart::CartItems::Create.new(cart: @cart, product_id: invalid_product_id,
                                                      quantity: 1)
        response = service.call

        assert_not response.success?
        assert_match(/Product must exist/, response.value)
      end
    end
  end
end

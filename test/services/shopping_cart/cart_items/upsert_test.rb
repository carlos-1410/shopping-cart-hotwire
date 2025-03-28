# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  module CartItems
    class UpsertTest < ActiveSupport::TestCase
      def setup
        @cart = Cart.create!
        @product = Product.create!(vendor: "Vendor", name: "Test Product", price: 1050)
      end

      test "creates a new cart item if not present" do
        quantity = 2
        expected_total_price = (@product.price * quantity).ceil(2)

        service = ShoppingCart::CartItems::Upsert.new(cart: @cart, product_id: @product.id,
                                                      quantity: quantity)
        response = service.call

        cart_item = @cart.cart_items.find_by(product_id: @product.id)

        assert response.success?
        assert_not_nil cart_item
        assert_equal quantity, cart_item.quantity
        assert_equal expected_total_price, cart_item.total_price
      end

      test "updates existing cart item if present" do
        cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 1,
                                     total_price: @product.price)

        new_quantity = 5
        expected_total_price = (@product.price * new_quantity).ceil(2)

        service = ShoppingCart::CartItems::Upsert.new(cart: @cart, product_id: @product.id,
                                                      quantity: new_quantity)
        response = service.call

        cart_item.reload

        assert response.success?
        assert_equal new_quantity, cart_item.quantity
        assert_equal expected_total_price, cart_item.total_price
      end

      test "does not create a cart item if quantity is zero or negative" do
        service = ShoppingCart::CartItems::Upsert.new(cart: @cart, product_id: @product.id,
                                                      quantity: 0)
        response = service.call

        assert_not response.success?
        assert_equal "Invalid quantity", response.value
        assert_nil @cart.cart_items.find_by(product_id: @product.id)
      end

      test "increments quantity with 'increment' operation" do
        cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 2,
                                     total_price: @product.price * 2)

        service = ShoppingCart::CartItems::Upsert.new(cart: @cart, product_id: @product.id,
                                                      operation: "increment")
        response = service.call

        cart_item.reload

        assert response.success?
        assert_equal 3, cart_item.quantity
        assert_equal @product.price * 3, cart_item.total_price
      end

      test "decrements quantity with 'decrement' operation" do
        cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 3,
                                     total_price: @product.price * 3)

        service = ShoppingCart::CartItems::Upsert.new(cart: @cart, product_id: @product.id,
                                                      operation: "decrement")
        response = service.call

        cart_item.reload

        assert response.success?
        assert_equal 2, cart_item.quantity
        assert_equal @product.price * 2, cart_item.total_price
      end

      test "decrement destroys the item when quantity is below 0" do
        cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 1,
                                     total_price: @product.price)

        service = ShoppingCart::CartItems::Upsert.new(cart: @cart, product_id: @product.id,
                                                      operation: "decrement")
        response = service.call

        assert response.success?
        assert_nil CartItem.find_by(product_id: cart_item.product_id)
      end
    end
  end
end

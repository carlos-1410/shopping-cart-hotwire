# frozen_string_literal: true

require "test_helper"

module Api
  module V1
    class CartItemsControllerTest < ActionDispatch::IntegrationTest
      def setup
        @cart = create(:cart)
        @product = create(:product)
        @cart_item = create(:cart_item,
                            cart: @cart,
                            product: @product,
                            quantity: 2,
                            total_price: @product.price * 2)
        @headers = { "X-Cart-ID" => @cart.id.to_s }
      end

      test "index returns all cart items for the cart" do
        get api_v1_cart_items_path, headers: @headers

        json_response = response.parsed_body
        assert_response :ok
        assert_equal 1, json_response.size
        assert_equal @cart_item.id, json_response.first["id"]
      end

      test "show returns the cart item" do
        get api_v1_cart_item_path(@cart_item), headers: @headers

        json_response = response.parsed_body
        assert_response :ok
        assert_equal @cart_item.id, json_response["id"]
      end

      test "upsert adds a new item if not in cart" do
        new_product = create(:product)
        post upsert_api_v1_cart_items_path,
             params: { product_id: new_product.id, quantity: 2 }, headers: @headers

        json_response = response.parsed_body

        assert_response :ok
        assert json_response["message"].present?,
               "Expected success message, got #{json_response.inspect}"
        assert_equal 2, @cart.cart_items.count, "Cart item count mismatch!"
      end

      test "upsert updates an existing cart item" do
        assert_no_difference -> { @cart.cart_items.count } do
          post upsert_api_v1_cart_items_path,
               params: { product_id: @cart_item.product_id, quantity: 5 }, headers: @headers
        end

        json_response = response.parsed_body
        assert_response :ok
        assert_equal "Your cart has been updated!", json_response["message"]
        assert_equal 5, @cart_item.reload.quantity
      end

      test "destroy removes a cart item" do
        assert_difference -> { @cart.cart_items.count }, -1 do
          delete api_v1_cart_item_path(@cart_item), headers: @headers
        end

        json_response = response.parsed_body
        assert_response :ok
        assert_equal "The product has been removed from your cart!", json_response["message"]
      end

      test "reset clears all cart items" do
        create(:cart_item, cart: @cart)

        assert_difference -> { @cart.cart_items.count }, -@cart.cart_items.count do
          delete reset_api_v1_cart_items_path, headers: @headers
        end

        json_response = response.parsed_body
        assert_response :ok
        assert_equal "Your cart has been emptied!", json_response["message"]
      end
    end
  end
end

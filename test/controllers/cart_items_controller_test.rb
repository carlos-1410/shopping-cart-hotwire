# frozen_string_literal: true

require "test_helper"

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @cart = Cart.create!
    @product = Product.create!(vendor: "Mesa Boogie", name: "Dual Rectifier", price: 250_000)
    @cart_item = CartItem.create!(cart: @cart, product: @product, quantity: 2, total_price: 500_000)

    ENV["TEST_CART_ID"] = @cart.id.to_s
  end

  def teardown
    ENV["TEST_CART_ID"] = nil
  end

  test "GET index renders successfully" do
    get cart_url
    assert_response :success
    assert_select "div", /Boogie/
  end

  test "POST upsert creates a new cart item" do
    new_product = Product.create!(vendor: "Paul Reed Smith", name: "Tremonti", price: 300_000)

    assert_difference "CartItem.count", 1 do
      post upsert_cart_items_url, params: {
        product_id: new_product.id,
        quantity: 1,
      }, as: :turbo_stream
    end

    assert_response :success
  end

  test "POST upsert updates an existing cart item" do
    assert_no_difference "CartItem.count" do
      post upsert_cart_items_url, params: {
        product_id: @product.id,
        quantity: 5,
      }, as: :turbo_stream
    end

    assert_response :success
    @cart_item.reload
    assert_equal 5, @cart_item.quantity
  end

  test "POST upsert with invalid quantity returns error" do
    new_product = Product.build(vendor: "Paul Reed Smith", name: "Tremonti", price: 300_000)
    post upsert_cart_items_url, params: {
      product_id: new_product.id,
      quantity: -1,
    }, as: :turbo_stream

    assert_response :unprocessable_entity
    assert_match "turbo-stream", @response.body
  end

  test "DELETE destroy removes the item" do
    assert_difference "CartItem.count", -1 do
      delete cart_item_url(@cart_item), as: :turbo_stream
    end

    assert_response :success
    assert_match "turbo-stream", @response.body
  end

  test "DELETE destroy with invalid ID returns error" do
    delete cart_item_url("invalid"), as: :turbo_stream

    assert_response :unprocessable_entity
    assert_match "turbo-stream", @response.body
  end

  test "DELETE reset clears all items" do
    assert_difference "CartItem.count", -1 do
      delete cart_reset_url, as: :turbo_stream
    end

    assert_response :success
    assert_match "turbo-stream", @response.body
  end

  test "DELETE reset with empty cart still responds successfully" do
    CartItem.delete_all

    delete cart_reset_url, as: :turbo_stream

    assert_response :success
    assert_match "turbo-stream", @response.body
  end
end

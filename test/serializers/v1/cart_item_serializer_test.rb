# frozen_string_literal: true

require "test_helper"

module V1
  class CartItemSerializerTest < ActiveSupport::TestCase
    def setup
      @cart = Cart.create!
      @product = Product.create!(
        vendor: "Vendor",
        name: "Test Product",
        price: 100,
        image: File.open("app/assets//images/raincoat.png")
      )
      @cart_item = @cart.cart_items.create!(product: @product, quantity: 2,
                                            total_price: @product.price * 2)

      @serializer = V1::CartItemSerializer.new(@cart_item)
      @serialization = ActiveModelSerializers::Adapter.create(@serializer).as_json
    end

    test "includes the expected attributes" do
      expected_keys = %i(cart_id id product product_id product_image quantity total_price)
      assert_equal expected_keys.sort, @serialization.keys.sort
    end

    test "serializes image correctly" do
      assert_match %r{/rails/active_storage/representations/redirect/.+/raincoat\.png},
                   @serialization[:product_image]
    end

    test "serializes product association correctly" do
      assert_equal @product.id, @serialization[:product][:id]
    end
  end
end

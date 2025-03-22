# frozen_string_literal: true

require "test_helper"

module V1
  class ProductSerializerTest < ActiveSupport::TestCase
    def setup
      @product = Product.create!(
        name: "Test Product",
        vendor: "Test Vendor",
        price: 1000,
        image: File.open("app/assets//images/raincoat.png")
      )
      @serializer = V1::ProductSerializer.new(@product)
      @serialization = ActiveModelSerializers::Adapter.create(@serializer).as_json
    end

    test "serializes the product with correct attributes" do
      expected_keys = %i(id name vendor price product_image)
      assert_equal @product.id, @serialization[:id]
      assert_equal @product.name, @serialization[:name]
      assert_equal @product.vendor, @serialization[:vendor]
      assert_equal @product.price, @serialization[:price]
      assert_equal @product.product_image, @serialization[:product_image]
      assert_equal expected_keys, @serialization.keys
    end

    test "product_image follows Active Storage URL pattern" do
      assert_match %r{/rails/active_storage/representations/redirect/.+/raincoat\.png},
                   @serialization[:product_image]
    end
  end
end

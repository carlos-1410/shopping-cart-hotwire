# frozen_string_literal: true

require "test_helper"

module Api
  module V1
    class ProductsControllerTest < ActionDispatch::IntegrationTest
      test "index returns products in descending order" do
        Product.destroy_all

        product1 = create(:product, created_at: 2.days.ago)
        product2 = create(:product, created_at: 1.day.ago)
        product3 = create(:product, created_at: 3.days.ago)

        get api_v1_products_path

        assert_response :success
        json_response = response.parsed_body

        returned_ids = json_response.map { |p| p["id"] }

        expected_order = [product2.id, product1.id, product3.id]
        assert_equal expected_order, returned_ids
      end

      test "destroy removes product and returns success message" do
        product = create(:product)

        assert_difference -> { Product.count }, -1 do
          delete api_v1_product_path(product)
        end

        assert_response :success
        json_response = response.parsed_body
        assert_equal "Product was successfully removed!", json_response["message"]
      end

      test "destroy fails when product deletion fails" do
        product = create(:product)
        Product.any_instance.stubs(:destroy_with_response)
          .returns(Response.failure("Cannot delete"))

        assert_no_difference -> { Product.count } do
          delete api_v1_product_path(product)
        end

        assert_response :unprocessable_entity
        json_response = response.parsed_body
        assert_equal "Cannot delete", json_response["errors"]
      end
    end
  end
end

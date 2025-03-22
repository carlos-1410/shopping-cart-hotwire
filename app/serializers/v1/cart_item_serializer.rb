# frozen_string_literal: true

module V1
  class CartItemSerializer < ActiveModel::Serializer
    attribute :id
    attribute :quantity
    attribute :total_price
    attribute :product_id
    attribute :cart_id
    attribute :product_image

    belongs_to :product

    def product_image
      object.product.product_image
    end
  end
end

# frozen_string_literal: true

module V1
  class ProductSerializer < ActiveModel::Serializer
    attribute :id
    attribute :name
    attribute :vendor
    attribute :price
    attribute :product_image

    delegate :product_image, to: :object
  end
end

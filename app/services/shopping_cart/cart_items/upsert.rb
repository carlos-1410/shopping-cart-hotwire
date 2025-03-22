# frozen_string_literal: true

module ShoppingCart
  module CartItems
    class Upsert
      def initialize(cart:, product_id:, quantity: 0)
        @cart = cart
        @product_id = product_id
        @quantity = quantity.to_i
      end

      def call
        if cart_item.present?
          ShoppingCart::CartItems::Update.new(cart:, cart_item:, quantity:).call
        else
          return Response.failure("Invalid quantity") if quantity <= 0

          ShoppingCart::CartItems::Create.new(cart:, product_id:, quantity:).call
        end
      end

      private

      attr_reader :cart, :product_id, :quantity

      def cart_item
        @cart_item ||= cart.cart_items.find_by(product_id:)
      end

      def product
        @product ||= Product.find_by(id: product_id)
      end
    end
  end
end

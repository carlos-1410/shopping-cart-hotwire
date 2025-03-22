# frozen_string_literal: true

module ShoppingCart
  module CartItems
    class Create
      def initialize(cart:, product_id:, quantity: 0)
        @cart = cart
        @product_id = product_id
        @quantity = quantity
      end

      def call # rubocop:disable Metrics/AbcSize
        return Response.failure("Product must exist") if product.blank?

        new_cart_item = cart.cart_items.create(product_id:, quantity:, total_price:)

        if new_cart_item.persisted?
          Response.success(new_cart_item)
        else
          Response.failure(new_cart_item.errors.full_messages.to_sentence)
        end
      end

      private

      attr_reader :cart, :product_id, :quantity

      def total_price
        (product.price * quantity).ceil(2)
      end

      def product
        @product ||= Product.find_by(id: product_id)
      end
    end
  end
end

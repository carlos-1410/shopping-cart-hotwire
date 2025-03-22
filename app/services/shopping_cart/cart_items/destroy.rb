# frozen_string_literal: true

module ShoppingCart
  module CartItems
    class Destroy
      def initialize(cart:, cart_item_id:)
        @cart = cart
        @cart_item_id = cart_item_id
      end

      def call
        return Response.failure("Product was not found in the cart.") if cart_item.blank?

        cart_item.destroy_with_response
      end

      private

      attr_reader :cart, :cart_item_id

      def cart_item
        @cart_item ||= cart.cart_items.find_by(id: cart_item_id)
      end
    end
  end
end

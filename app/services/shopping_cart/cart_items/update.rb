# frozen_string_literal: true

module ShoppingCart
  module CartItems
    class Update
      def initialize(cart:, cart_item:, quantity: 0)
        @cart = cart
        @cart_item = cart_item
        @quantity = quantity
      end

      def call
        if quantity.positive?
          cart_item.save_with_response(quantity:, total_price:)
        else
          ShoppingCart::CartItems::Destroy.new(cart: cart, cart_item_id: cart_item.id).call
        end
      end

      private

      attr_reader :cart, :cart_item, :quantity

      def total_price
        (product.price * quantity).ceil(2)
      end

      def product
        @product ||= cart_item.product
      end
    end
  end
end

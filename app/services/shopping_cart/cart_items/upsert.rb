# frozen_string_literal: true

module ShoppingCart
  module CartItems
    class Upsert
      def initialize(cart:, product_id:, quantity: 0, operation: nil)
        @operation = operation
        @cart = cart
        @product_id = product_id
        @quantity = quantity.to_i
      end

      def call
        if cart_item.present?
          ShoppingCart::CartItems::Update.new(cart: cart, cart_item: cart_item,
                                              quantity: incoming_quantity).call
        else
          return Response.failure("Invalid quantity") if quantity <= 0

          ShoppingCart::CartItems::Create.new(cart:, product_id:, quantity:).call
        end
      end

      private

      attr_reader :operation, :cart, :product_id, :quantity

      # Unless the quantity is passed explicitly, e.g. from products#index, just increment it
      def incoming_quantity
        return quantity.to_i unless operation

        operation == "increment" ? (cart_item.quantity + 1) : (cart_item.quantity - 1)
      end

      def cart_item
        @cart_item ||= cart.cart_items.find_by(product_id:)
      end

      def product
        @product ||= Product.find_by(id: product_id)
      end
    end
  end
end

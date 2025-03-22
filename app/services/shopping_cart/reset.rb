# frozen_string_literal: true

module ShoppingCart
  class Reset
    def initialize(cart:)
      @cart = cart
    end

    def call
      return Response.failure("Your cart was not created, please reload the page.") if cart.blank?

      cart.cart_items.destroy_all.then { Response.success(nil) }
    end

    private

    attr_reader :cart
  end
end

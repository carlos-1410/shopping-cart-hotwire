# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :force_test_cart if Rails.env.test?

  private

  # This is to ensure the correct cart is being picked up in each test
  # to avoid shared state inconsistency
  def force_test_cart
    @cart = Cart.find_by(id: ENV["TEST_CART_ID"]) if ENV["TEST_CART_ID"].present?
  end
end

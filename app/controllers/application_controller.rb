# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :initialize_cart

  private

  def initialize_cart # rubocop:disable Metrics/AbcSize
    if Rails.env.test? && request.headers["X-Cart-ID"].present?
      @cart = Cart.find_by(id: request.headers["X-Cart-ID"])
    else
      @cart ||= Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] = @cart.id
    end
  end
end

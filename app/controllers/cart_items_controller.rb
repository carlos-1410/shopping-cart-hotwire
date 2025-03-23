# frozen_string_literal: true

class CartItemsController < ApplicationController
  include ApplicationHelper

  def index
    @cart_items = CartItem.includes(:product).where(cart_id: @cart.id).order(created_at: :asc)
  end

  def upsert # rubocop:disable Metrics/AbcSize
    response = ShoppingCart::CartItems::Upsert.new(cart: @cart, product_id: params[:product_id],
                                                   quantity: params[:quantity],
                                                   operation: params[:operation]).call

    if response.success?
      @cart_item = response.value
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to cart_items_path, notice: "Your cart has been updated!" }
      end
    else
      render turbo_stream: turbo_toast(message: response.value, type: "danger"),
             status: :unprocessable_entity
    end
  end

  def destroy # rubocop:disable Metrics/AbcSize
    response = ShoppingCart::CartItems::Destroy.new(cart: @cart, cart_item_id: params[:id]).call

    if response.success?
      @cart_item_id = params[:id]
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to cart_items_path, notice: "The product has been removed from your cart!"
        end
      end
    else
      render turbo_stream: turbo_toast(message: response.value, type: "danger"),
             status: :unprocessable_entity
    end
  end

  def reset
    response = ShoppingCart::Reset.new(cart: @cart).call

    if response.success?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to cart_items_path, notice: "Your cart has been emptied!" }
      end
    else
      render turbo_stream: turbo_toast(message: response.value, type: "error"),
             status: :unprocessable_entity
    end
  end
end

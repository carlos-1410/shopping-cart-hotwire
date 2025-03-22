# frozen_string_literal: true

class CartItemsController < ApplicationController
  def index
    cart_items = CartItem.eager_load(:product).where(cart_id: @cart.id).order(created_at: :asc)

    render json: cart_items,
            each_serializer: ::V1::CartItemSerializer,
            status: :ok
  end

  def show
    render json: cart_item, serializer: ::V1::CartItemSerializer
  end

  def upsert
    response = ShoppingCart::CartItems::Upsert.new(cart: @cart,
                                                    product_id: params[:product_id],
                                                    quantity: params[:quantity]).call

    if response.success?
      render json: {
        cart_item: ::V1::CartItemSerializer.new(response.value).serializable_hash,
        message: "Your cart has been updated!",
      }, status: :ok
    else
      render json: { errors: response.value }, status: :unprocessable_entity
    end
  end

  def destroy
    response = ShoppingCart::CartItems::Destroy.new(cart: @cart, cart_item_id: params[:id]).call

    if response.success?
      render json: { message: "The product has been removed from your cart!" }, status: :ok
    else
      render json: { errors: response.value, status: :unprocessable_entity }
    end
  end

  def reset
    response = ShoppingCart::Reset.new(cart: @cart).call

    if response.success?
      render json: { message: "Your cart has been emptied!" }, status: :ok
    else
      render json: { errors: response.value, status: :unprocessable_entity }
    end
  end

  private

  def cart_item
    @cart_item ||= CartItem.find_by(id: params[:id])
  end
end

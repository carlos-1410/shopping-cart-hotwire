# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :product, only: [:edit, :destroy]

  def index
    @products = Product.order(created_at: :desc)
  end

  def new
    @product = Product.new
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create # rubocop:disable Metrics/AbcSize
    @product = Product.find_or_initialize_by(product_attributes.except(:image, :price_in_dollars))
    %i(price_in_dollars image).each do |attribute|
      next if product_attributes[attribute].nil?

      @product.public_send("#{attribute}=", product_attributes[attribute])
    end

    respond_to do |format|
      if @product.save
        format.turbo_stream
        format.html { redirect_to products_path }
      else
        format.turbo_stream { render :create_failure }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if product.update(product_attributes)
        format.turbo_stream
        format.html do
          redirect_to products_path, notice: "The product has been updated successfully!"
        end
      else
        format.turbo_stream { render :update_failure }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    products = Product.all

    respond_to do |format|
      if products.any?
        format.turbo_stream
      else
        format.turbo_stream { render :destroy_empty_state }
      end
      format.html { redirect_to products_path, notice: "The product was successfully removed!" }
    end
  end

  private

  def product
    @product ||= Product.find(params[:id])
  end

  def product_attributes
    params.expect(product: [:name, :vendor, :price_in_dollars, :image])
  end
end

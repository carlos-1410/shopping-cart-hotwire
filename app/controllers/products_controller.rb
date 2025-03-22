# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :product, only: [:edit, :show, :destroy]

  def index
    @products = Product.order(created_at: :desc)
  end

  def show; 
  end

  def new
    @product = Product.new
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("product_#{@product.id}",
                                                  partial: "products/form",
                                                  locals: { product: @product })
      end
      format.html
    end
  end

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @product = Product.find_or_initialize_by(product_attributes.except(:image, :price_in_dollars))
    %i(price_in_dollars image).each do |attribute|
      next if product_attributes[attribute].nil?

      @product.public_send("#{attribute}=", product_attributes[attribute])
    end

    respond_to do |format|
      if @product.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("products",
                                partial: "products/product",
                                locals: { product: @product }),
            turbo_stream.append("notifications",
                                partial: "shared/toast",
                                locals: { message: "The product has been created successfully!",
                                          type: "success", }),
            turbo_stream.replace("new_product", "")
          ]
        end
        format.html { redirect_to products_path }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_product",
                                                    partial: "products/form",
                                                    locals: { product: @product })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if product.update(product_attributes)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("product_#{@product.id}", partial: "products/product",
                                                            locals: { product: @product }),
            turbo_stream.append("notifications",
                                partial: "shared/toast",
                                locals: { message: "The product has been updated successfully!",
                                          type: "success", })
          ]
        end
        format.html do
          redirect_to products_path, notice: "The product has been updated successfully!"
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("product_#{@product.id}",
                                                    partial: "products/form",
                                                    locals: { product: @product })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy

    products = Product.all
    message = "The product was successfully removed!"

    respond_to do |format|
      if products.any?
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@product),
            turbo_stream.append("notifications",
                                partial: "shared/toast",
                                locals: { message: message, type: "success" })
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@product),
            turbo_stream.replace("products", partial: "products/empty_state"),
            turbo_stream.append("notifications",
                                partial: "shared/toast",
                                locals: { message: message, type: "success" })
          ]
        end
      end
      format.html { redirect_to products_path, notice: message }
    end
  end

  private

  def product
    @product ||= Product.find(params[:id])
  end

  def product_attributes
    params.require(:product).permit(:name, :vendor, :price_in_dollars, :image)
  end
end

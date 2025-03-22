# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :cart_items, dependent: :delete_all
  has_one_attached :image

  with_options presence: true do
    validates :name, :vendor, :price
    validates :price, numericality: { greater_than: 0 }
    validates :price_in_dollars, numericality: { greater_than: 0 }
  end

  before_validation :convert_price_to_cents
  after_update_commit :update_cart_items_price

  def product_image
    return unless persisted? && image.attached?

    Rails.application.routes.url_helpers.rails_representation_url(
      image.variant(resize_to_fit: [150, 250], format: :webp),
      only_path: true
    )
  end

  def price_in_dollars
    price.present? ? price.to_d / 100 : nil
  end

  def price_in_dollars=(dollar_amount)
    self.price = (dollar_amount.to_d * 100).round(0) if dollar_amount.present?
  end

  private

  def convert_price_to_cents
    return if price.present? && price > 100

    self.price = (price_in_dollars.to_d * 100).round(0) if price_in_dollars.present?
  end

  def update_cart_items_price
    cart_items.each { _1.update(total_price: price * _1.quantity) }
  end
end

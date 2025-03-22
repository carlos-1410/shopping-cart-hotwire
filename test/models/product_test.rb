# frozen_string_literal: true

require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Product.new(name: "Test Product", vendor: "Test Vendor", price: 1050)
  end

  test "invalid when required attributes are missing" do
    product = build(:product, vendor: nil, name: nil, price: nil)

    assert product.invalid?

    %i(vendor name price).each do |field|
      assert product.errors.added?(field, :blank)
    end
  end

  test "is valid with all attributes" do
    assert @product.valid?
  end

  test "is invalid with non-positive price" do
    @product.price = 0
    assert_not @product.valid?
  end

  test "converts price to cents before validation" do
    @product.price_in_dollars = 23.45
    @product.valid?
    assert_equal 2345, @product.price
  end

  test "price_in_dollars returns price in dollars" do
    assert_equal 10.50, @product.price_in_dollars
  end

  test "price_in_dollars= sets price in cents" do
    @product.price_in_dollars = 15.99
    assert_equal 1599, @product.price
  end

  test "product_image returns nil when no image is attached" do
    assert_nil @product.product_image
  end

  test "product_image returns URL when image is attached" do
    @product.save!
    @product.image.attach(io: File.open("app/assets//images/raincoat.png"),
                          filename: "raincoat.png",
                          content_type: "image/png")

    assert @product.image.attached?

    @product.reload

    assert_match %r{/rails/active_storage/representations/redirect/.+/raincoat\.png},
                 @product.product_image
  end

  test "updates cart item prices when price changes" do
    cart = Cart.create!
    cart_item = CartItem.create!(cart: cart, product: @product, quantity: 2,
                                 total_price: @product.price * 2)

    @product.update!(price: 2000) # Update price
    cart_item.reload

    assert_equal 4000, cart_item.total_price
  end
end

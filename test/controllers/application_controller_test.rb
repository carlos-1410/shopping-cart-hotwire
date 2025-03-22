# frozen_string_literal: true

require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @cart = Cart.create!
    @session = { cart_id: @cart.id }
  end

  test "initialize_cart assigns an existing cart if session exists" do
    get root_path, params: {}, headers: { "rack.session" => { cart_id: @cart.id } }

    assert_equal @cart.id, session[:cart_id]
  end

  test "initialize_cart creates a new cart if session is nil" do
    get root_path
    assert_not_nil assigns(:cart)
    assert_not_nil session[:cart_id]
  end
end

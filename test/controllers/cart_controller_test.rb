# frozen_string_literal: true

require "test_helper"

class CartControllerTest < ActionDispatch::IntegrationTest
  def setup
    @cart_url = cart_path
  end

  test "should get show" do
    get @cart_url
    assert_response :success
  end
end

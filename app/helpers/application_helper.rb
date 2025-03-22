# frozen_string_literal: true

module ApplicationHelper
  def cents_to_amount(amount)
    return if amount.nil?

    format("%.2f", amount.to_d / 100)
  end
end

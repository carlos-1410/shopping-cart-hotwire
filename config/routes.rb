# frozen_string_literal: true

Rails.application.routes.draw do
  get "cart", to: "cart_items#index"
  delete "cart/reset", to: "cart_items#reset"

  resources :cart_items, only: [:destroy] do
    collection do
      post :upsert
    end
  end

  resources :products

  root "products#index"
end

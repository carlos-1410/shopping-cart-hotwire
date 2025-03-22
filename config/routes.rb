# frozen_string_literal: true

Rails.application.routes.draw do
  get "cart", to: "cart#show"

  resources :cart_items, only: [:index, :show, :destroy] do
    collection do
      post :upsert
      delete :reset
    end
  end

  resources :products

  root "products#index"
end

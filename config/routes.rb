Rails.application.routes.draw do


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "static_pages#home"

  resources :users, only: [:show, :edit, :update, :destroy] do
    collection do
      patch 'update-avatar'
      patch 'update-password'
      patch 'update-profile'
    end
  end

  post '/cart/create_order', to: 'cart#create_order', as: 'create_order'

  get 'cart', to: 'cart#show'
  post 'cart/add'
  post 'cart/remove'
  get 'checkouts/success', to: 'checkouts#success'
  get 'orders/index'

  resources :games, only: [:show]
  resources :genres, only: [:show]
end

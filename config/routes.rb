# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    get 'sessions/new', as: 'new_session'
    delete 'sessions', to: 'sessions#destroy', as: 'session'

    resources :bulletins

    get 'categories', to: 'categories#index'
    get 'categories/:id', to: 'categories#show', as: 'category'

    namespace :admin do
      resources :categories, except: %i[show]
    end

    root 'bulletins#index'
  end
end

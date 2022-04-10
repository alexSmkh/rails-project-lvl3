# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    get 'auth/new', as: :new_auth
    delete 'auth', to: 'auth#destroy'

    resources :bulletins

    root 'bulletins#index'
  end
end

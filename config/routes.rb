# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    get 'auth/new', as: :new_auth
    delete 'auth', to: 'auth#destroy'
  end
end

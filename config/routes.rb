# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resource :session, only: %i[new destroy]

    resources :bulletins do
      patch 'archive', on: :member
      patch 'moderate', on: :member
    end

    resource :profile

    namespace :admin do
      resources :categories, except: :show
      resources :bulletins, only: %i[index destroy] do
        patch 'archive', on: :member
        patch 'reject', on: :member
        patch 'publish', on: :member
      end
      get 'moderation', to: 'bulletins#moderation', as: 'moderation'
    end

    root 'bulletins#index'
  end
end

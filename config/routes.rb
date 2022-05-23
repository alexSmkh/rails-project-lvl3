# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resource :session, only: %i[new destroy]

    resources :bulletins do
      member do
        patch 'archive'
        patch 'moderate'
      end
    end

    resource :profile

    namespace :admin do
      resources :categories, except: :show
      resources :bulletins, only: %i[index destroy] do
        member do
          patch 'archive'
          patch 'reject'
          patch 'publish'
        end
      end
      get 'moderation', to: 'bulletins#moderation', as: 'moderation'
    end

    root 'bulletins#index'
  end
end

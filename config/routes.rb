# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    get 'sessions/new', as: 'new_session'
    delete 'sessions', to: 'sessions#destroy', as: 'session'

    resources :bulletins do
      patch 'archive', on: :member
      patch 'moderate', on: :member
    end

    resources :categories, only: %i[index show]

    get :profile, to: 'profiles#index'

    namespace :admin do
      resources :categories, except: :show
      resources :bulletins, only: :index do
        patch 'archive', on: :member
        patch 'reject', on: :member
        patch 'publish', on: :member
      end
      get 'admin', to: 'bulletins#moderation', as: 'moderation'
    end

    root 'bulletins#index'
  end
end

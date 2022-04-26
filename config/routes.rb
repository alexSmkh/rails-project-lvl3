# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    get 'sessions/new', as: 'new_session'
    delete 'sessions', to: 'sessions#destroy', as: 'session'

    resources :bulletins

    resources :categories, only: %i[index show]

    namespace :admin do
      resources :categories, except: :show
      resources :bulletins, only: :index do
        get 'archive', to: 'bulletins#archive'
        get 'reject', to: 'bulletins#reject'
        get 'publish', to: 'bulletins#publish'
      end
      get 'admin', to: 'bulletins#moderation', as: 'moderation'
    end

    root 'bulletins#index'
  end
end

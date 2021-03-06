require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end

  devise_scope :user do
    post :set_email, controller: :omniauth_callbacks, as: :set_user_email
  end

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :revote
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions do
    concerns :votable, :commentable

    resources :answers, shallow: true do
      concerns :votable, :commentable
      patch :best, on: :member
    end
    resources :subscriptions, only: [:create, :destroy]
  end

  resources :attachments, only: [:destroy]
  resource :search, only: [:show]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
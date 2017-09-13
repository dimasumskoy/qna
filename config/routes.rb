Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

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
  end

  resources :attachments, only: [:destroy]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
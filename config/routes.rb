Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :revote
    end
  end

  resources :questions, concerns: :votable do

    resources :answers, concerns: :votable, shallow: true do
      patch :best, on: :member

      resources :comments, only: [:create]
    end

    resources :comments, only: [:create]
  end

  resources :attachments, only: [:destroy]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
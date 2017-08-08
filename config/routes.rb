Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    patch :vote_up, on: :member
    patch :vote_down, on: :member
    patch :revote, on: :member
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      patch :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  root to: 'questions#index'
end
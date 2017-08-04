Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      patch :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :votes, only: [:vote_up, :vote_down, :revote] do
    post :vote_up, on: :collection
    post :vote_down, on: :collection
    post :revote, on: :collection
  end

  root to: 'questions#index'
end
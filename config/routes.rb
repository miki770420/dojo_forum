Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :posts do
    resources :replies
  end

  resources :feeds, only: [:index]

  root "posts#index"

  resources :users, only: [:edit, :update, :show] do
    member do
      post :invite
      post :accept
      post :ignore
    end
  end

  resources :categories, only: [:show]

  namespace :admin do
    root "categories#index"
    resources :users, only: [:index, :update]
    resources :categories
  end

end

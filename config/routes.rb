Rails.application.routes.draw do
  resources :labels, only: [:index, :new, :create, :edit, :update, :destroy]
  root "sessions#new"
  resources :tasks do
    get '/search', to: 'tasks#index'
  end
  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  namespace :admin do
    resources :users
  end
end

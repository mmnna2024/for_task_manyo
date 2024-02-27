Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks do
    get '/search', to: 'tasks#index'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

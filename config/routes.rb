Rails.application.routes.draw do
  root 'sessions#new'
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    get 'settings', to: 'settings#index'
    put 'settings', to: 'settings#update'
    # Add other routes as we build out

    # All items routes (We should need them all)
    resources :items
  end
  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  # Session
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'login', to: 'sessions#destroy', as: :logout
  # Signup
  get 'signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'
  
  get "up" => "rails/health#show", as: :rails_health_check
end

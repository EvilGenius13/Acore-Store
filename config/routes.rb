Rails.application.routes.draw do
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

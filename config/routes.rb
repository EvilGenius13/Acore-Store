Rails.application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'
  
  get "up" => "rails/health#show", as: :rails_health_check
end

Rails.application.routes.draw do
  root 'categories#index'

  resources :skills
  resources :categories
end

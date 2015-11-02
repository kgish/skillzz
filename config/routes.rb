Rails.application.routes.draw do
  root 'skills#index'

  resources :skills
  resources :categories
end

Rails.application.routes.draw do
  root 'skills#index'

  resources :skills
end

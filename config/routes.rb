Rails.application.routes.draw do
  namespace :admin do
  get 'application/index'
  end

  devise_for :users
  root 'categories#index'

  resources :categories do
    resources :skills
  end
end

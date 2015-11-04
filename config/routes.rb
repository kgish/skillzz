Rails.application.routes.draw do
  namespace :admin do
    get 'application/index'
    resources :categories, only: [:new, :create, :destroy]
  end

  devise_for :users
  root 'categories#index'

  resources :categories, only: [:index, :show, :edit, :update] do
    resources :skills
  end
end

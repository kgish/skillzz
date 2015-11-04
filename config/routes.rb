Rails.application.routes.draw do

  namespace :admin do
    root 'application#index'
    resources :categories, only: [:new, :create, :destroy]
    resources :users
  end

  devise_for :users
  root 'categories#index'

  resources :categories, only: [:index, :show, :edit, :update] do
    resources :skills
  end
end

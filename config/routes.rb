Rails.application.routes.draw do

  namespace :admin do
    root 'application#index'
    resources :categories, only: [:new, :create, :destroy]
    resources :users do
      member do
        patch :archive
      end
    end
  end

  devise_for :users
  root 'categories#index'

  resources :categories, only: [:index, :show, :edit, :update] do
    resources :skills
  end

  resources :skills, only: [] do
    resources :tags, only: [] do
      member do
        delete :remove
      end
    end
  end

end

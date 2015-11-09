Rails.application.routes.draw do

  get 'welcome/index'
  get 'skills', to: 'skills_all#index'
  get 'tags', to: 'tags_all#index'

  namespace :admin do
    root 'application#index'
    resources :categories, only: [:new, :create, :destroy]
    resources :users do
      member do
        patch :archive
      end
    end
  end

  namespace :worker do
    root 'application#index'
    resources :profile, only: [:show, :edit, :update]
  end

  namespace :customer do
    root 'application#index'
    resources :search, only: [:show, :edit, :update]
  end

  devise_for :users
  root 'welcome#index'

  resources :categories, only: [:index, :show, :edit, :update] do
    resources :skills do
      collection do
        get :search
      end
    end
  end

  resources :skills, only: [] do
    resources :tags, only: [] do
      member do
        delete :remove
      end
    end
  end

end

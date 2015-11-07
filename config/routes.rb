Rails.application.routes.draw do

  get 'welcome/index'

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

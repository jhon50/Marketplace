Rails.application.routes.draw do

  resources :produtos do
    collection do
      get :search
    end
  end

  resources :lojas

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  #get 'home/index'

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

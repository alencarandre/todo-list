Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :lists, except: [:show] do
    resources :list_tasks do
      get '/new', to: 'list_tasks#new'
    end
  end

  namespace :lists do
    resources :mine, only: [:index]
  end

  root "home#index"
end

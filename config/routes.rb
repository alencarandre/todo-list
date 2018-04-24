Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :lists, except: [:show] do
    get 'mark_as_opened', to: "lists#mark_as_opened"
    get 'mark_as_closed', to: "lists#mark_as_closed"
    get 'mark_as_favorite', to: 'lists#mark_as_favorite'
    get 'mark_as_unfavorite', to: 'lists#mark_as_unfavorite'

    resources :list_favorites, only: [:create]

    resources :list_tasks do
      get '/new', to: 'list_tasks#new'

      get 'mark_as_opened', to: 'list_tasks#mark_as_opened'
      get 'mark_as_closed', to: 'list_tasks#mark_as_closed'
    end
  end

  namespace :lists do
    resources :mine, only: [:index]
    resources :public, only: [:index]
    resources :favorites, only: [:index]
  end

  root "home#index"
end

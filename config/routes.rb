Rails.application.routes.draw do

  resources :genres
  root 'movies#index'

  resources :movies do
    resources :reviews
    resources :favorites, only: %i[create destroy]
  end

  resource :session, only: %i[new create destroy]
  get 'signin' => 'sessions#new'

  resources :users
  get 'signup' => 'users#new'
end

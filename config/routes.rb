Rails.application.routes.draw do
  resources :users
  resource :verifications

  root to: 'users#index'

  # get 'auth/:provider', as: "facebook_login"
  match 'auth/facebook/callback', to: 'sessions#create', via: [:get, :post], as: :auth
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  get 'signout', to: 'sessions#destroy', to: redirect('/'), as: 'signout', via: [:get, :post]

end

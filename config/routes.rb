Rails.application.routes.draw do
  resources :users
  resource :verifications

  root to: 'users#index'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', to: redirect('/'), as: 'signout', via: [:get, :post]

end

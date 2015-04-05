Rails.application.routes.draw do
  get 'about' => 'general#about', as: :about

  match '/auth/:provider/callback' => 'auth_token#create', via: :get
  match '/auth/failure' => 'auth_token#failure', via: :get
  # match '/signout' => 'sessions#destroy', :as => :signout, via: :get
  match '/signin' => 'auth_token#new', :as => :signin, via: :get

  match 'auth' => 'auth#authenticate', via: :post

  resources :subjects
  root 'general#index'
end

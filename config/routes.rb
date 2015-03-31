Rails.application.routes.draw do
  get 'about' => 'home#about', as: :about

  match '/auth/:provider/callback' => 'auth_token#create', via: :get
  match '/auth/failure' => 'auth_token#failure', via: :get
  # match '/signout' => 'sessions#destroy', :as => :signout, via: :get
  match '/signin' => 'auth_token#new', :as => :signin, via: :get

  match 'auth' => 'auth#authenticate', via: :post

  # for testing Json Web Token and authorization
  match '/secured_thing' => 'secured_thing#show', via: :get

  resources :subjects
  root 'home#index'
end

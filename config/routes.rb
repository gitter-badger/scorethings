Rails.application.routes.draw do
  match '/auth/:provider/callback' => 'auth_token#create', via: :get
  match '/auth/failure' => 'auth_token#failure', via: :get

  root 'dashboard#index'

  match '/twitter/lists' => 'twitter#lists', via: :get
end

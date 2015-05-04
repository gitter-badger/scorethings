Rails.application.routes.draw do
  match '/auth/twitter/callback' => 'auth_token#create', via: :get, as: :twitter_auth
  match '/auth/failure' => 'auth_token#failure', via: :get

  root 'dashboard#index'

  match '/twitter/lists' => 'twitter#lists', via: :get, as: :twitter_lists
end

Rails.application.routes.draw do
  match '/auth/twitter/callback' => 'auth_token#create', via: :get, as: :twitter_auth
  match '/auth/failure' => 'auth_token#failure', via: :get

  root 'dashboard#index'

  match '/twitter/lists' => 'twitter#lists', via: :get, as: :twitter_lists

  match '/scores' => 'scores#create', via: :post, as: :create_score

  match '/scores/:id' => 'scores#show', via: :get, as: :show_score
end

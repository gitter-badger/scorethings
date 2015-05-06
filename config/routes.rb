Rails.application.routes.draw do
  match '/auth/twitter/callback' => 'auth_token#create', via: :get, as: :twitter_auth
  match '/auth/failure' => 'auth_token#failure', via: :get

  root 'dashboard#index'

  match '/things/search' => 'things#search', via: :get, as: :things_search

  match '/scores' => 'scores#create', via: :post, as: :create_score

  match '/scores/:id' => 'scores#show', via: :get, as: :show_score

  match '/scores/:score_id/subscores' => 'subscores#create', via: :post, as: :create_subscore
  match '/scores/:score_id/subscores/:id' => 'subscores#update', via: :put, as: :update_subscore

  match '/criteria' => 'criteria#index', via: :get, as: :criteria_index
end

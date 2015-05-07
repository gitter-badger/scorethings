Rails.application.routes.draw do
  # FIXME even though I modified the callback URL settings at apps.twitter.com,
  # I think omniauth middleware has the old/non nested URL callback hardcoded somewhere
  # until I can fix that, I'll just keep this outside of the namespace as a hack
  match '/auth/twitter/callback' => 'api/v1/auth_token#create', via: :get, as: :buggy_old_twitter_auth

  namespace :api do
    namespace :v1 do
      match '/auth/twitter/callback' => 'auth_token#create', via: :get, as: :twitter_auth
      match '/auth/failure' => 'auth_token#failure', via: :get


      match '/things/search' => 'things#search', via: :get, as: :things_search

      match '/scores' => 'scores#create', via: :post, as: :create_score

      match '/scores/:id' => 'scores#show', via: :get, as: :show_score

      match '/scores/:score_id/subscores' => 'subscores#create', via: :post, as: :create_subscore
      match '/scores/:score_id/subscores/:id' => 'subscores#update', via: :put, as: :update_subscore

      match '/criteria' => 'criteria#index', via: :get, as: :criteria_index
    end
  end

  root 'dashboard#index'
end

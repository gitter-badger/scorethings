Rails.application.routes.draw do
  # FIXME even though I modified the callback URL settings at apps.twitter.com,
  # I think omniauth middleware has the old/non nested URL callback hardcoded somewhere
  # until I can fix that, I'll just keep this outside of the namespace as a hack
  match '/auth/twitter/callback' => 'api/v1/auth_token#create', via: :get, as: :buggy_old_twitter_auth

  namespace :api do
    namespace :v1 do
      match '/auth/twitter/callback' => 'auth_token#create', via: :get, as: :twitter_auth
      match '/auth/failure' => 'auth_token#failure', via: :get


      match '/twitter/handle_search' => 'twitter#handle_search', via: :get, as: :twitter_handle_search
      match '/twitter/user_info' => 'twitter#user_info', via: :get, as: :twitter_user_info

      match '/scores' => 'scores#create', via: :post, as: :create_score

      match '/scores' => 'scores#index', via: :get, as: :score_index

      match '/scores/:id' => 'scores#show', via: :get, as: :show_score

      match '/scores/:score_id/subscores' => 'subscores#create', via: :post, as: :create_subscore
      match '/scores/:score_id/subscores/:id' => 'subscores#update', via: :put, as: :update_subscore

      match '/users/current_user_info' => 'users#current_user_info', via: :get, as: :current_user_info

      match '/users/:id/criteria' => 'users#criteria', via: :get, as: :user_criteria

      match '/criteria/system' => 'criteria#system', via: :get, as: :system_criteria
      match '/criteria' => 'criteria#create', via: :post, as: :create_criteria
    end
  end

  get "api" => proc { [404, {}, ['Invalid API endpoint']] }
  get "api/*path" => proc { [404, {}, ['Invalid API endpoint']] }
  root 'dashboard#index'
end

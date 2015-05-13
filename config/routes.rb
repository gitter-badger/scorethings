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

      resources :scores, except: [:edit, :new]

      get '/users/:id/scores' => 'users#scores'

      get '/categories' => 'categories#index'
    end
  end

  get "api" => proc { [404, {}, ['Invalid API endpoint']] }
  get "api/*path" => proc { [404, {}, ['Invalid API endpoint']] }
  root 'dashboard#index'
end

Rails.application.routes.draw do
  # FIXME even though I modified the callback URL settings at apps.twitter.com,
  # I think omniauth middleware has the old/non nested URL callback hardcoded somewhere
  # until I can fix that, I'll just keep this outside of the namespace as a hack
  get '/auth/:provider/callback' => 'api/v1/auth_token#create'
  get '/auth/:provider' => 'api/v1/auth_token#create'

  namespace :api do
    namespace :v1 do
      get '/auth/:provider/callback' => 'auth_token#create'
      get '/auth/failure' => 'auth_token#failure'

      resources :things, only: [:create, :show]

      get '/potential_things/search' => 'potential_things#search'
      get '/potential_things/search_images' => 'potential_things#search_images'
      get '/potential_things/:resource_name' => 'potential_things#show'

      resources :scores, only: [:create, :show, :update, :destroy]

      get '/users' => 'users#show'
      get '/users/search' => 'users#search'
      get '/users/current' => 'users#current'
      put '/users/:id' => 'users#update'
      delete '/users' => 'users#destroy'
    end
  end

  get "api" => proc { [404, {}, ['Invalid API endpoint']] }
  get "api/*path" => proc { [404, {}, ['Invalid API endpoint']] }
  get "/*path" => redirect("/?goto=%{path}")
  root 'dashboard#index'
end

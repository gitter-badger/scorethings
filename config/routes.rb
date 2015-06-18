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

      get '/things/:resource_name' => 'things#show'
      post '/things/:resource_name' => 'things#create'

      get '/dbpedia_things/search' => 'dbpedia_things#search'
      get '/dbpedia_things/:resource_name' => 'dbpedia_things#show'

      get '/thing_images/:resource_name' => 'thing_images#show'

      resources :scores, only: [:create, :show, :update, :destroy]

      get '/users' => 'users#show'
      get '/users/search' => 'users#search'
      get '/users/current' => 'users#current'
      put '/users' => 'users#update'
      delete '/users' => 'users#destroy'
    end
  end

  get "api" => proc { [404, {}, ['Invalid API endpoint']] }
  get "api/*path" => proc { [404, {}, ['Invalid API endpoint']] }
  get "/*path" => redirect("/?goto=%{path}")
  root 'dashboard#index'
end

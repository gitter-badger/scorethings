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

      get '/scored_things/:id' => 'scored_things#show'
      get '/scored_things/:id/scores' => 'scored_things#scores'

      get '/things/search' => 'things#search'
      get '/things/:thing_id' => 'things#find'

      get '/scores/search' => 'scores#search'
      resources :scores, only: [:create, :show, :update, :destroy]

      get '/stats' => 'stats#index'

      get '/users' => 'users#show'
      get '/users/search' => 'users#search'
      get '/users/current' => 'users#current'
      put '/users' => 'users#update'
      delete '/users' => 'users#destroy'

      get '/criteria' => 'criteria#index'
    end
  end

  get 'api' => proc { [404, {}, ['Invalid API endpoint']] }
  get 'api/*path' => proc { [404, {}, ['Invalid API endpoint']] }

  get '*path' => 'dashboard#index'

  root 'dashboard#index'

end

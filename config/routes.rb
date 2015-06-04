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

      resources :thing_references, except: [:destroy, :edit, :new, :index]

      get '/things/:type/:external_id' => 'things#show'
      get '/things/search' => 'things#search'

      resources :scores, except: [:edit, :new, :index]


      get '/settings' => 'settings#show'
      put '/settings' => 'settings#update'

      get '/users' => 'users#show'
      get '/users' => 'users#search'

      # for current user only
      put '/users' => 'users#update'
      delete '/users' => 'users#destroy'
    end
  end

  get "api" => proc { [404, {}, ['Invalid API endpoint']] }
  get "api/*path" => proc { [404, {}, ['Invalid API endpoint']] }
  root 'dashboard#index'
end

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

      get '/things/search' => 'things#search'
      get '/things/find' => 'things#find'

      post '/things/:thing_type/:external_id/scores' => 'scores#score_thing'

      resources :things, except: [:destroy, :edit, :new] do
        get 'scores' => 'things#scores'
      end

      get '/scores/search' => 'scores#search'
      resources :scores, except: [:edit, :new]

      resources :score_lists, except: [:edit, :new]

      get '/users/:id/scores' => 'users#scores'

      get '/score_categories' => 'score_categories#index'
    end
  end

  get "api" => proc { [404, {}, ['Invalid API endpoint']] }
  get "api/*path" => proc { [404, {}, ['Invalid API endpoint']] }
  root 'dashboard#index'
end

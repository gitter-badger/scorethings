source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
ruby '2.2.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# UsejUglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'puma'

gem 'omniauth-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'
gem 'omniauth-soundcloud'

gem 'jwt'
gem 'angular-rails-templates', '~> 0.1.4'
gem 'mongoid', git: 'https://github.com/mongoid/mongoid.git'
gem 'mongoid-embedded-errors'

gem 'angular-ui-bootstrap-rails'

gem 'twitter'
gem 'google-api-client'
gem 'trollop'
gem 'dalli'
gem 'api_cache'
gem 'mongoid_search'
gem 'mongoid_token'

group :production, :staging do
  gem 'heroku_rails_deflate'
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'

  gem 'guard-rspec'
  gem 'guard-livereload'
  #gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'guard'
  gem 'guard-spork'
  gem 'childprocess'
  gem 'rspec-mocks'
  gem 'mongoid-rspec', '~> 2.1.0'
  gem 'factory_girl_rails'
  gem 'database_cleaner'

  gem 'fakeweb', '~> 1.3'
end

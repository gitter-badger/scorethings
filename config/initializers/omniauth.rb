require 'omniauth-oauth2'

# options from https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview#openssl
ssl_options = {}
unless Rails.env.production?
  ssl_options[:client_options] = {
      access_type: 'offline',
      ssl: {
        ca_file: '/usr/local/etc/openssl/certs/ca-bundle.crt',
        ca_path: '/usr/local/etc/openssl/certs'
      }
    }
end


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :soundcloud, ENV['SOUNDCLOUD_CLIENT_ID'], ENV['SOUNDCLOUD_CLIENT_SECRET'], ssl_options
end
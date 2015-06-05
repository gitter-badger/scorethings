require 'omniauth-oauth2'

# options from https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview#openssl
# and https://github.com/zquestz/omniauth-google-oauth2/issues/175#issuecomment-94294393
google_options = {
    name: 'google',
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.profile',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 50
}

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
require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scorethings
  module ThingTypes
    # ThingReference types
    TWITTER_ACCOUNT = 'twitter_account'
    GITHUB_REPOSITORY = 'github_repository'
    SOUNDCLOUD_TRACK = 'soundcloud_track'
    TMDB_MOVIE = 'tmdb_movie'
    TMDB_TV = 'tmdb_tv'
    HASHTAG = 'hashtag'
  end

  class Application < Rails::Application

  end
end
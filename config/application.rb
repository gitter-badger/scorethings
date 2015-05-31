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
    # Thing types
    TWITTER_ACCOUNT = 'twitter_account'
    YOUTUBE_VIDEO = 'youtube_video'
    HASHTAG = 'hashtag'
  end

  class Application < Rails::Application

  end
end
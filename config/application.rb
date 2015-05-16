require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scorething
  module ThingTypes
    # Thing types
    TWITTER_ACCOUNT = 'TWITTER_ACCOUNT'
    YOUTUBE_VIDEO = 'YOUTUBE_VIDEO'
    HASHTAG = 'HASHTAG'
  end

  class Application < Rails::Application
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.assets.enabled = true
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components', 'font-awesome', 'fonts')
  end
end
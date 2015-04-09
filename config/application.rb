require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require "neo4j/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YeAskMe
  class Application < Rails::Application
    config.generators { |g| g.orm :neo4j }

    config.neo4j.session_type = :server_db
    config.neo4j.session_path = ENV["GRAPHENEDB_URL"] || 'http://localhost:7474'
    config.assets.paths << Rails.root.join("vendor", "assets", "images")
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.svg)
  end
end

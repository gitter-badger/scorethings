# Be sure to restart your server when you modify this file.
Rails.application.config.assets.paths << Rails.root.join('bower_components')
Rails.application.config.assets.enabled = true
# Version of your assets, change this if you want to expire all your assets.

# Add additional assets to the asset load path
Rails.application.config.assets.paths << Rails.root.join('bower_components', 'angular-emoji-filter-hd', 'dist')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.

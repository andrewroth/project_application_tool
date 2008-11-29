# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_controller.fragment_cache_store = :file_store, RAILS_ROOT + "/tmp/cache"


# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

ActionMailer::Base.smtp_settings = {
  :address => '192.168.250.4',
  :domain => 'granvillehosting.com'
}

# eager loading messes up active scaffold and a bunch of other things
config.eager_load_paths = []


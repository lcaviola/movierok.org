# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

config.action_controller.fragment_cache_store = :file_store, 'tmp/cache'

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
  :address => "mail.movierok.org" ,
  :port       => 25,
  :domain => "mail.movierok.org" ,
  :authentication => :login,
  :user_name => 'admin@movierok.org' ,
  :password  => "sudoweb1337"
}

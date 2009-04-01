# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2'

require 'rubygems'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

module QE
  def self.prefix() 'form_' end
end

# questionnaire engine config
Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( 
    #{RAILS_ROOT}/app/sweepers
  )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :ruby

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options

  config.action_mailer.raise_delivery_errors = false
  
  # Load Engines first
  #config.plugins = [:engines, :engines_model_mixins, :questionnaire_engine, :reference_engine, :all]
  config.plugins = [:questionnaire_engine, :reference_engine, :all]

  # shhhh secret!  apparently this is required in 2.x
  config.action_controller.session = { :secret => "In the beginning was the Word, and the Word was with God, and the Word was God." }

  # Some people want plugins not be be reloadable.  I disagree and definitely want plugins
  # to be reloadable since we use them for code sharing.
  #
  # http://weblog.techno-weenie.net/2007/1/26/understanding-the-rails-plugin-initialization-process
  # http://www.ruby-forum.com/topic/134860#600630
  # http://dev.rubyonrails.org/ticket/5852
  config.reload_plugins = true
end

ActiveRecord::Base.default_timezone = :utc # Store all times in the db in UTC

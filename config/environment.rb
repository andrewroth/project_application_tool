# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2'

require 'rubygems'
gem 'soap4r'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')

require 'add_plugin_load_paths_after_loading_plugins'

# questionnaire engine config
module QE
  mattr_accessor :prefix
  self.prefix = "form_"
end

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
  # config.action_controller.session_store = :active_record_store

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
  config.plugins = [:engines, :questionnaire_engine, :reference_engine, :all]

  # shhhh secret!  apparently this is required in 2.x
  config.action_controller.session = { :secret => "In the beginning was the Word, and the Word was with God, and the Word was God." }

  # Some people want plugins not be be reloadable.  I disagree and definitely want plugins
  # to be reloadable since we use them for code sharing.
  #
  # http://weblog.techno-weenie.net/2007/1/26/understanding-the-rails-plugin-initialization-process
  # http://www.ruby-forum.com/topic/134860#600630
  # http://dev.rubyonrails.org/ticket/5852
  config.after_initialize {
    #ActiveSupport::Dependencies.load_once_paths = []
  }
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
  inflect.singular /^campus$/i, 'campus'
  inflect.irregular 'campus', 'campuses'
end

# Include your application configuration below

ExceptionNotifier.exception_recipients = %w(andrew.roth@c4c.ca helpdesk@c4c.ca)
ExceptionNotifier.sender_address = %w(spt@campusforchrist.org)


# Include formatting methods globally
require 'formatting'
module ActiveScaffold::Helpers::ListColumns
  include Formatting
end

# Include the fixed in_place_editor
require 'in_place_editing'

ActiveRecord::Base.default_timezone = :utc # Store all times in the db in UTC

# testing and sqlite3 should use one database
ActiveRecord::Base.table_name_prefix = ActiveRecord::Base.configurations[RAILS_ENV]['database'] + '.' unless
  RAILS_ENV == 'test' || 
  ActiveRecord::Base.configurations[RAILS_ENV]['dbfile'] || 
  (caller.find{ |c| c["rake"] || c["test"] } && !caller.find{ |c| c["mongrel"] || c["webrick"] })

#require 'tzinfo' # Use tzinfo library to convert to and from the users timezone
#ENV['TZ'] = 'UTC' # This makes Time.now return time in UTC

# Add my own override for table_exists
require 'active_record_base_table_name'

$LOAD_PATH.sort!{ |a,b| ag = a['gem']; bg = b['gem']; if ag and bg then a <=> b elsif ag then -1 elsif bg then +1 else 0 end }

# support a command line option --rcov_baseline which will load in all models and controllers, 
# so that rcov has a baseline of all the files (roughly) that are used.
if ARGV.include?('--rcov_baseline')
  puts "Loading each controller and model once to get the base coverage in."
  
  # seems that we need application.rb loaded first for all the other controllers to work,
  # not sure why it doesn't automatically fine application.rb when it hits Application class
  require "#{RAILS_ROOT}/app/controllers/application.rb"

  Dir["#{RAILS_ROOT}/app/models/*.rb", "#{RAILS_ROOT}/app/controllers/*.rb"].each do |file|
      require file
  end
end

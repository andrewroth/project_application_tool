# lib/tasks/legacy.rake
# 
# - prepare all legacy databases with rake db:test:prepare:legacy
# - db:test:*:legacy_db to run any db:test: task on database legacy_db
# 
# list your legacy dbs here:
legacy_dbs = %w(ciministry_development authservice_development)

# datetime needs the same time formats -- some legacy formats
# might use datetimes..
load 'environment.rb'
class DateTime
  include ActiveSupport::CoreExtensions::Time::Conversions
end

def prepend(prefix, array)
  array.collect { |item| prefix + item }
end

def dump_db
  require 'active_record/schema_dumper'
  File.open(ENV['SCHEMA'] || "db/schema.rb", "w") do |file|
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
  end
end

def load_db
  file = ENV['SCHEMA'] || "db/schema.rb"
  load(file)
end

namespace :db do
  namespace :legacy do
    desc "copies all legacy database structure(s) to the current env database" 
    task :clone do
      prepend("db:test:clone:legacy:", legacy_dbs).each do |task|
        Rake::Task[task].invoke
      end
    end
  end
  
  namespace :test do
    
    # append a prepare legacy after the basic prepare task
    # because test:* tasks will call prepare first
    task :prepare do
      Rake::Task["db:test:clone:legacy"].invoke
    end
    
    task :clone do
      Rake::Task["db:test:clone:legacy"].invoke
    end
    
    namespace :clone do
      desc "copies all legacy databases structure(s) to the test database" 
      task :legacy do
        prepend("db:test:clone:legacy:", legacy_dbs).each do |task|
          RAILS_ENV = 'test'
          Rake::Task[task].invoke
        end
      end
      
      namespace :legacy do
        legacy_dbs.each do |legacy_db|
          desc "copies #{legacy_db} structure to the RAILS_ENV database" 
          task legacy_db => :environment do
            ActiveRecord::Schema.verbose = false
            # dump legacy db
            ActiveRecord::Base.establish_connection(legacy_db)
            dump_db
            # load to env
            ActiveRecord::Base.establish_connection(RAILS_ENV)
            load_db
          end # end task
        end # end each legacy_db
      end # end legacy namespace
    end # end clone namespace
  end
end

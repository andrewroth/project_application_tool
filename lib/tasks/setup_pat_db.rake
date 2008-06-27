require 'config/environment'

namespace :db do
  namespace :pat do
    desc "Setup for the pat, to be run while installing.  Loads all schemas in db/schema* and installs some required database rows (ex default user)."
    task :setup do
      for schema in Dir.glob('db/schema*')
        load schema
      end
    end
  end
end

require 'ftools'

namespace :db do
  namespace :proxy do
    desc "Backs up database.yml then copies database.proxy.yml to database.yml"
    task :activate do
      File.copy "#{Rails.root}/config/database.yml", "#{Rails.root}/config/database.yml.backup"
      File.copy "#{Rails.root}/config/database.proxy.yml", "#{Rails.root}/config/database.yml"
      puts "Backed up database.yml then copied database.proxy.yml to database.yml"
    end
  end
end

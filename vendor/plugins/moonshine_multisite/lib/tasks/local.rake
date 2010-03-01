MOONSHINE_MULTISITE_ROOT = "#{File.dirname(__FILE__)}/../.."
RAILS_ROOT = "#{MOONSHINE_MULTISITE_ROOT}/../../.."
require MOONSHINE_MULTISITE_ROOT + '/lib/multisite_helper.rb'
require MOONSHINE_MULTISITE_ROOT + '/lib/rake_helper.rb'

task :aliases do
  multisite_config_hash[:apps].keys.each do |app|
    host = ENV['host'] || '127.0.0.1'
    aliass = "#{app}.local"
    unless system("grep #{aliass} /etc/hosts")
      system "echo '127.0.0.1\t#{aliass}' >> /etc/hosts"
      puts "Add #{aliass}"
    end
  end
end

def track_branch(branch)
  remote_branch = "origin/#{branch}"
  if system("git branch -r | egrep '  #{remote_branch}$' > /dev/null") && !system("git branch | egrep '( |\\*) #{branch}$' > /dev/null")
    system("git branch #{branch} #{remote_branch}")
  end
end

namespace :git do
  desc "sets git branches for all remote branches"
  task :branches do
    multisite_config_hash[:servers].keys.each do |server|
      multisite_config_hash[:stages].each do |stage|
        track_branch "#{server}.#{stage}"
      end
    end
    track_branch "dev"
    track_branch "master"
  end
end

namespace :db do
  desc "Backs up database.yml then copies database.reloader.yml to database.yml"
  task :reloader do
    system "cp #{Rails.root}/config/database.yml #{Rails.root}/config/database.yml.backup"
    system "cp #{Rails.root}/config/database.reloader.yml #{Rails.root}/config/database.yml"
    puts "Backed up database.yml then copied database.reloader.yml to database.yml"
  end
end

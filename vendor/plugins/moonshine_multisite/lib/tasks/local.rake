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

namespace :git do
  desc "sets git branches for all remote branches"
  task :branches do
    multisite_config_hash[:servers].keys.each do |server|
      multisite_config_hash[:stages].each do |stage|
        branch = "#{server}.#{stage}"
        remote_branch = "origin/#{branch}"
        if system("git branch -r | egrep '  #{remote_branch}$' > /dev/null") && !system("git branch | egrep '( |\\*) #{branch}$' > /dev/null")
          system("git branch #{branch} #{remote_branch}")
        end
      end
    end
  end
end

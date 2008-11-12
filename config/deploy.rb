ENV['target'] ||= 'prod'
ENV['host'] ||= 'ministryapp.com'
ENV['port'] ||= 40022
ENV['user'] ||= 'andrew'

puts "target = '#{ENV['target']}'"
puts "host = '#{ENV['host']}'"
puts

role :app, ENV['host']
role :web, ENV['host']
role :db,  ENV['host'], :primary => true

ssh_options[:port] = ENV['port']
set :user, ENV['user']

set :application, "Project Application Tool"
set :repository,  "https://svn.ministryapp.com/pat/trunk"

if ENV['target'] == 'dev'
  set :deploy_to, "/var/www/dev.pat.ministryapp.com"
  RAILS_ENV = 'development'
elsif ENV['target'] == 'demo'
  set :deploy_to, "/var/www/demo.pat.ministryapp.com"
  RAILS_ENV = 'production'
elsif ENV['target'] == 'prod'
  set :deploy_to, "/var/www/pat.ministryapp.com"
  RAILS_ENV = 'production'
end

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

desc "Restart the web server"
deploy.task :restart, :roles => :app do
  # sudo "/opt/lsws/bin/lswsctrl restart"
  run "touch #{current_path}/tmp/restart.txt"
end

deploy.task :before_migrate do
  run "cd #{current_path}; RAILS_ENV=#{RAILS_ENV} rake db:setup:pat"
end

unless ENV['target'] == 'demo'
  deploy.task :after_symlink do
    run "cp #{File.join(deploy_to, 'database.yml')} #{File.join(current_path, 'config', 'database.yml')}"
  end
end

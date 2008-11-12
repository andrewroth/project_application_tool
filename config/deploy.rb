ENV['target'] ||= 'prod'
ENV['system'] ||= 'p2c'

if %w(ma mh).include? ENV['system']
  ENV['host'] ||= 'ministryapp.com'
  ENV['domain'] ||= 'pat.ministryapp.com'
  ENV['port'] ||= '40022'
elsif %w(p2c pc).include? ENV['system']
  ENV['host'] ||= 'pat.powertochange.org' # NOTE won't work until Brent sets this up
  ENV['domain'] ||= 'pat.powertochange.org'
  ENV['port'] ||= '22'
end

ENV['user'] ||= %x[whoami].chomp
ENV['deploy_to'] ||= "#{ENV['target']}.#{ENV['domain']}"

if ENV['target'] == 'dev'
  RAILS_ENV = 'development'
elsif ENV['target'] == 'demo'
  RAILS_ENV = 'production'
elsif ENV['target'] == 'prod'
  RAILS_ENV = 'production'
end

puts
puts "host = #{ENV['host']}:#{ENV['port']}"
puts "user = #{ENV['user']}"
puts "env = #{RAILS_ENV}"
puts "deploy_to = #{ENV['deploy_to']}"
puts

role :app, ENV['host']
role :web, ENV['host']
role :db,  ENV['host'], :primary => true

ssh_options[:port] = ENV['port']
set :user, ENV['user']

set :application, "Project Application Tool"
set :repository,  "https://svn.ministryapp.com/pat/trunk"
set :deploy_to, "/var/www/#{ENV['deploy_to']}"

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

require 'find'
require 'etc'

ENV['target'] ||= 'dev'
ENV['system'] ||= 'p2c'

ENV['user'] = 'deploy'

set :application, "Project Application Tool"
set :repository,  "https://svn.ministryapp.com/pat/branches/rails_2.2/"

if %w(ma mh).include? ENV['system']
  ENV['host'] ||= 'ministryapp.com'
  ENV['domain'] ||= 'pat.ministryapp.com'
  ENV['port'] ||= '40022'
elsif %w(p2c pc).include? ENV['system']
  ENV['host'] ||= 'pat2.powertochange.org'
  ENV['domain'] ||= 'pat.powertochange.org'
  ENV['port'] ||= '22'
end

ENV['deploy_to'] ||= "/var/www/#{if ENV['target'] == 'prod' then 
                       ENV['domain'] else "#{ENV['target']}.#{ENV['domain']}" end}"

if ENV['env']
  RAILS_ENV = ENV['env']
elsif ENV['target'] == 'dev'
  RAILS_ENV = 'development'
  set :repository,  "https://svn.ministryapp.com/pat/branches/rails_2.3_remove_engines/"
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

set :deploy_to, ENV['deploy_to']

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

def link_shared(p)
  run "ln -s #{shared_path}/#{p} #{release_path}/#{p}"
end

unless ENV['target'] == 'demo'
  deploy.task :after_symlink do
<<<<<<< HEAD:config/deploy.rb
    # set up tmp dir
    run "mkdir -p -m 770 #{shared_path}/tmp/{cache,sessions,sockets,pids}"
    run "rm -Rf #{release_path}/tmp"
    link_shared 'tmp'

    # log
    run "rm -Rf #{release_path}/log"
    link_shared 'log'

    # other shared files
    link_shared 'config/database.yml'
    link_shared 'public/event_groups'
  end
end


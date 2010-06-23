require 'find'
require 'etc'

#if fetch(:stage) =~ /staging|dev/ then ENV['target'] = 'dev' end
#if fetch(:stage) =~ /prod/ then ENV['target'] = 'prod' end

ENV['target'] ||= 'dev'
ENV['system'] ||= 'p2c'

ENV['user'] = 'deploy'

set :application, "Project Application Tool"
set :scm, "git"
set :repository,  "git://github.com/andrewroth/project_application_tool.git"

if %w(ma mh).include? ENV['system']
  ENV['host'] ||= 'ministryapp.com'
  ENV['domain'] ||= 'pat.ministryapp.com'
  ENV['port'] ||= '40022'
elsif %w(p2c pc).include? ENV['system']
  ENV['host'] ||= 'pat2.powertochange.org'
  ENV['domain'] ||= 'pat.powertochange.org'
  ENV['port'] ||= '22'
end

#ENV['deploy_to'] ||= "/var/www/#{if ENV['target'] == 'prod' then 
#                       ENV['domain'] else "#{ENV['target']}.#{ENV['domain']}" end}"
ENV['deploy_to'] = "/var/www/pat.cdm.powertochange.org"

if ENV['target'] == 'dev'
  set :branch, "p2c.dev.live"
end

if ENV['env']
  RAILS_ENV = ENV['env']
elsif ENV['target'] == 'dev'
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

set :deploy_to, ENV['deploy_to']

# remove old deploys after each new deploy
set :use_sudo, false
after "deploy", "deploy:cleanup"

desc "Restart the web server"
deploy.task :restart, :roles => :app do
  # sudo "/opt/lsws/bin/lswsctrl restart"
  run "touch #{current_path}/tmp/restart.txt"
end

def link_shared(p, o = {})
  if o[:overwrite]
    run "rm -Rf #{release_path}/#{p}"
  end

  run "ln -s #{shared_path}/#{p} #{release_path}/#{p}"
end

unless ENV['target'] == 'demo'
  deploy.task :after_symlink do
    # set up tmp dir
    run "mkdir -p -m 770 #{shared_path}/tmp/{cache,sessions,sockets,pids}"
    run "rm -Rf #{release_path}/tmp"
    link_shared 'tmp'

    # other shared files / folders
    link_shared 'log', :overwrite => true
    link_shared 'config/database.yml'
    link_shared 'public/event_groups'
    if RAILS_ENV == 'development'
      link_shared 'config/environments/development.rb', :overwrite => true
    end
    # TODO: test ln's for pat2. www.pat and www.pat2
    run "rm -Rf #{release_path}/tmp/cache/*"
    run "mkdir -p #{release_path}/tmp/cache/views/pat.powertochange.org"
    run "ln -s #{release_path}/tmp/cache/views/pat.powertochange.org #{release_path}/tmp/cache/views/pat2.powertochange.org"
    run "cd #{release_path} && git submodule init && git submodule update"
  end
end

set :application, "Project Application Tool"
set :repository,  "https://svn.ministryapp.com/pat/trunk"

ssh_options[:port] = 40022
set :user, "andrew"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/pat.ministryapp.com"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "ministryapp.com"
role :web, "ministryapp.com"
role :db,  "ministryapp.com", :primary => true

desc "Restart the web server"
deploy.task :restart, :roles => :app do
  sudo "/opt/lsws/bin/lswsctrl restart"
end

set :application, 'pat'
set :keep_releases, '3'
role :app, 'pat.powertochange.org'
role :db, 'pat.powertochange.org'
set :user, 'deploy'
set :deploy_to, "/var/www/pat.powertochange.org"
set :branch, "master"
set :repository, "git://github.com/andrewroth/project_application_tool.git"
set :scm, "git"

desc "Add linked files after deploy and set permissions"
task :after_update_code, :roles => :app do
  run <<-CMD
    ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
    mkdir -p -m 770 #{shared_path}/tmp/{cache,sessions,sockets,pids} &&
    ln -s #{shared_path}/public/attachments #{release_path}/public/attachments &&
    ln -s #{shared_path}/public/event_groups #{release_path}/public/event_groups
  CMD

  run "cd #{release_path} && git submodule init"
  run "cd #{release_path} && git submodule update"
end

namespace :deploy do
  task :restart do
    run "cd #{current_path}/tmp && touch restart.txt"
  end

  task :update_code, :except => { :no_release => true } do
    #on_rollback { run "rm -rf #{release_path}; true" }
    strategy.deploy!
    finalize_update
  end
end

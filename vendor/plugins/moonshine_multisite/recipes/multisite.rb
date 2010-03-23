namespace :moonshine do
  namespace :multisite do
    namespace :secure do
      desc "Downloads the moonshine secure folder to app/manifests/assets/private"
      task :download do
        set :user, fetch(:private_user)
        server fetch(:private_host), :private
        FileUtils.mkdir_p "app/manifests/assets/"
        parent.download fetch(:private_path), "app/manifests/assets/private",
          :recursive => true,
          :hosts => fetch(:private_host)
      end

      desc "Replaces the moonshine secure folder with app/manifests/assets/private"
      task :upload do
        set :user, fetch(:private_user)
        run "rm -rf #{fetch(:private_path)}.backup*", :hosts => fetch(:private_host)
        run "mv #{fetch(:private_path)} #{fetch(:private_path)}.backup", 
          :hosts => fetch(:private_host)
        parent.upload "app/manifests/assets/private", fetch(:private_path), 
          :recursive => true,
          :hosts => fetch(:private_host)
      end
    end
  end
end

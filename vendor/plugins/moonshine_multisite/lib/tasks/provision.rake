MOONSHINE_MULTISITE_ROOT = "#{File.dirname(__FILE__)}/../.."
RAILS_ROOT = "#{MOONSHINE_MULTISITE_ROOT}/../../.."
require MOONSHINE_MULTISITE_ROOT + '/lib/multisite_helper.rb'
require MOONSHINE_MULTISITE_ROOT + '/lib/rake_helper.rb'

require 'rubygems'
begin
  require('capistrano/cli')
rescue Exception => e
end
require 'ftools'

namespace :provision do
  namespace :this do
    # *** replace this task with your countries provision method
    # Canada's method is here as an example
    desc "provisions this computer"
    task :dev do
      STDOUT.print "Enter the password for #{%x[whoami].chomp}@localhost: "
      @password = STDIN.gets.chomp
      ENV['HOSTS'] = '127.0.0.1'
      provision(:c4c, multisite_config_hash[:servers][:c4c], true)
      ENV['skipsetup'] = 'true'
      provision(:p2c, multisite_config_hash[:servers][:p2c], true)
      puts %|

Provisioning your local computer is complete.

To download all the database info, run:

      cap c4c pull:dbs:utopian sensitive=true user=deploy
      cap p2c pull:dbs:utopian sensitive=true user=deploy

|
    end
    task :server do
      STDOUT.print "Enter the password for deploy@localhost: "
      @local_password = STDIN.gets.chomp
      STDOUT.print "Enter the password for deploy@pat.powertochange.org: "
      @p2c_password = STDIN.gets.chomp
      # download private
      @password = @p2c_password
      new_cap "p2c", nil, nil, true
      run_cap nil, "moonshine:secure:download_private"
      # now provision
      @password = @local_password
      @cap_config = nil # force new password to take effect
      ENV['HOSTS'] = '127.0.0.1'
      provision(:c4c, multisite_config_hash[:servers][:c4c], false)
      ENV['skipsetup'] = 'true'
      provision(:p2c, multisite_config_hash[:servers][:p2c], false)
    end
  end

  multisite_config_hash[:servers].each do |server, server_config|
    desc "Provision the #{server} server"
    task server do
      provision(server, server_config, false)
    end

    namespace server do
      multisite_config_hash[:apps].keys.each do |app|
        if server_has_app(server, app)
          desc "Provision the #{app} app on the #{server} server"
          task app do
            ENV['skipsetup'] = 'true'
            provision(server, server_config, false, [ app ])
          end
          desc "Provision the #{app} app on the #{server} server for a development system"
          namespace app do
            task :utopian do
              throw "You probably want to specify the host" unless ENV['HOSTS']
              ENV['skipsetup'] = 'true'
              provision(server, server_config, true, [ app ])
            end
          end
        end
      end
    end

    namespace server do
      desc "Provision the #{server} server for a development system"
      task :utopian do
        throw "You probably want to specify the host" unless ENV['HOSTS']
        ENV['skipsetup'] = 'true'
        provision(server, server_config, true)
      end
    end
=begin
        namespace server do
          desc "Provision the #{server} server with empty databases."
          task :vanilla do
            provision(server, server_config, :vanilla, false)
          end
          namespace :vanilla do
            desc "Provision the #{server} server with empty databases using the utopian database naming."
            task :utopian do
              provision(server, server_config, :vanilla, true)
            end
          end
          multisite_config_hash[:servers].keys.each do |source_server|
            namespace :seed do
              desc "Provision the #{server} server seeding databases from #{source_server} (ie. using #{server} naming for the databases, and copying data locally)"
              task source_server do
                provision(server, server_config, :seed, false, source_server)
              end
              namespace source_server do
                desc "Provision the #{server} server seeding databases from #{source_server} (ie. using #{server} utopian naming for the databases, and copying data locally)"
                task :utopian do
                  provision(server, server_config, :seed, true, source_server)
                end
              end
            end
            namespace :mirror do
              desc "Provision the #{server} server mirroring databases from #{source_server} (ie. using #{source_server} naming for the databases, and copying data locally)"
              task source_server do
                provision(server, server_config, :mirror, false, source_server)
              end
              namespace source_server do
                desc "Provision the #{server} server mirroring databases from #{source_server} (ie. using #{source_server} utopian naming for the databases, and copying data locally)"
                task :utopian do
                  provision(server, server_config, :mirror, true, source_server)
                end
              end
            end
          end
        end
=end
  end
end


# fix rake collisions with capistrano
undef :symlink
undef :ruby
undef :install

def run_shell(cmd)
  debug "[SH ] #{cmd}"
  system cmd
end

def run_shell_forked(cmd)
  debug "[SH ] #{cmd}"
  if fork.nil?
    exec(cmd)
    #Kernel.exit!
  end
  Process.wait
end

def new_cap(server, app, stage, utopian)
  # save password
  if @cap_config
    @password = @cap_config.fetch(:password)
  end
  @cap_config = Capistrano::Configuration.new
  Capistrano::Configuration.instance = @cap_config
  @cap_config.logger.level = Capistrano::Logger::TRACE
  if @password
    @cap_config.set(:password, @password)
  else
    @cap_config.set(:password) { Capistrano::CLI.password_prompt }
  end
  @cap_config.load "Capfile"
  @cap_config.set(:utopian_override, utopian)
  @cap_config.set(:application, app)
  #@cap_config.load "config/deploy"
  #@cap_config.load :file => "/opt/local/lib/ruby/gems/1.8/gems/capistrano-ext-1.2.1/lib/capistrano/ext/multistage.rb"
  unless @multistage_path
    version = Gem.source_index.find_name('capistrano-ext').first.version.to_s
    @multistage_path = Gem.path.collect{ |p|
    "#{p}/gems/capistrano-ext-#{version}/lib/capistrano/ext/multistage.rb"
    }.find{ |p|
      File.exists?(p)
    }
  end
  @cap_config.load :file => @multistage_path
  if server && stage
    @cap_config.find_and_execute_task("#{server}/#{stage}")
  elsif server
    @cap_config.find_and_execute_task("#{server}")
  end
  @cap_config.find_and_execute_task("multistage:ensure")
end

def run_cap(stage, cmd)
  debug "[CAP] #{stage} #{cmd}"
  @cap_config.find_and_execute_task(cmd)
end

=begin
def cap_download_private(stage)
  debug "[DBG] Downloading private config files from secure repository"
  run_shell_forked "cap #{stage} moonshine:secure:download_private"
end

def cap_upload_certs(stage)
  debug "[DBG] Uploading private certs to server"
  #run_shell_forked "cap #{stage} moonshine:secure:upload_certs"
  run_cap stage, "moonshine:secure:upload_certs"
end
=end

def provision(server, server_config, utopian, apps_filter = nil)
  debug "[DBG] setup #{server} utopian=#{utopian}"
  debug "[DBG] config #{server_config.inspect}"
  tmp_dir = "#{RAILS_ROOT}/tmp"
  first_app = true
  for app, repo in multisite_config_hash[:apps]
    next if apps_filter && !apps_filter.include?(app)
    debug "============================= #{app.to_s.ljust(20, " ")} ============================="
    next if repo.nil? || repo == ''
    app_root = "#{tmp_dir}/#{app}"

    # set up all apps on server
    multisite_config_hash[:stages].each do |stage|
      cap_stage = "#{server}/#{stage}"
      utopian_name = utopian_db_name(server, app, stage)
      debug "----------------------------- #{app.to_s.ljust(10, " ")} #{stage.to_s.ljust(10, " ")} ----------------------------"

      # update and make sure this app is supposed to go on this server
      if repo == '' || %x[git ls-remote #{repo} #{server}.#{stage}] == ''
        debug "[WRN] Skipping installation of #{app} on #{server} since no #{server}.#{stage} branch found"
        next
      end

      new_cap server, app, stage, utopian

      if @cap_config.fetch(:skip_deploy, false)
        debug "[WRN] Skipping installation of #{app} on #{server} since skip_deploy flag is set"
        next
      end

      # deploy
      server_moonshine_folder = "#{app_root}/config/deploy/#{server}"
      stage_moonshine_file = "#{server_moonshine_folder}/#{stage}_moonshine.yml"
      if first_app && ENV['skipsetup'] != 'true'
        run_cap cap_stage, "deploy:setup"
        first_app = false
      end
      run_cap cap_stage, "moonshine:setup_directories"

      # copy the database file
      if utopian
        #db_file = File.read(File.join(MOONSHINE_MULTISITE_ROOT, "/assets/public/database_configs/database.#{utopian_name}.yml"))
        db_file = File.read(File.join(RAILS_ROOT, "/vendor/plugins/database_git_proxy/generators/database_git_proxy/templates/database.proxy.yml"))
      else
        db_file = File.read("app/manifests/assets/private/database_configs/database.#{utopian_name}.yml")
      end
      @cap_config.put db_file, "#{@cap_config.fetch(:shared_path)}/config/database.yml"
      # upload certs if possible
      if @cap_config.fetch(:ssl, false) && @cap_config.fetch(:certs, nil).is_a?(Hash)
        @cap_config.fetch(:certs).each do |local_file, remote_file|
          base_name = File.basename(remote_file)
          tmp_file = "/tmp/#{base_name}"
          @cap_config.upload local_file, tmp_file
          @cap_config.sudo "mkdir -p #{File.dirname(remote_file)}"
          @cap_config.sudo "mv #{tmp_file} #{remote_file}"
        end
      end

      run_cap cap_stage, "deploy"
      run_remote_rake("git:branches", @cap_config.current_path, @cap_config)
    end
  end
end

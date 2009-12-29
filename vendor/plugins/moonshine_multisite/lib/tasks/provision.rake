MOONSHINE_MULTISITE_ROOT = "#{File.dirname(__FILE__)}/../.."
RAILS_ROOT = "#{MOONSHINE_MULTISITE_ROOT}/../../.."
require MOONSHINE_MULTISITE_ROOT + '/lib/multisite_helper.rb'

begin # some servers don't like this, don't know why
  require 'capistrano/cli'
rescue MissingSourceFile => ex
end
require 'ftools'

namespace :moonshine do
  namespace :multisite do
    namespace :provision do
      multisite_config_hash[:servers].each do |server, server_config|
        desc "Provision the #{server} server"
        task server do
          provision(server, server_config, false)
        end
        namespace server do
          desc "Provision the #{server} server"
          task :utopian do
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
  @cap_config.find_and_execute_task("#{server}/#{stage}")
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

# TODO: all these comments are out of date now
#
# :database_mode: is one of
#
# :vanilla
#
#   Creates the databases, and runs rake db:seed.
#
# :mirror
#
#   Copies the database info from the seed server locally, using the names specified
#   in moonshine_multisite.yml for the seed server.  If utopian is true, the database
#   names will be done with utopian naming (ex. p2c_pat_dev)
#
# :seed
#
#   Similar to mirror, but uses the local server names.  For example, you could
#   make a server "server2" seeded from "server" if you wanted to move away from
#   "server2" and keep the database data.  Utopian will also work for this option,
#   if you want the new server to use utopian naming instead of what's given in
#   moonshine_multisite.yml (not sure why you'd want this, but it's there).
#
# :utopian: is a flag to override the database naming on the new server to always
# use the utopian names.  You might want to do this if you've been forced to support
# an old legacy naming convention, but are now moving to a new server.  Or if you're
# setting up a local computer for development and would prefer the consistent names.
#
#
def provision(server, server_config, utopian)
  debug "[DBG] setup #{server} utopian=#{utopian}"
  debug "[DBG] config #{server_config.inspect}"
  tmp_dir = "#{RAILS_ROOT}/tmp"
  first_app = true
  for app, repo in multisite_config_hash[:apps]
    debug "============================= #{app.to_s.ljust(20, " ")} ============================="
    next if repo.nil? || repo == ''
    app_root = "#{tmp_dir}/#{app}"

    # set up all apps on server
    first = true # first time deploy:setup should run
    multisite_config_hash[:stages].each do |stage|
      cap_stage = "#{server}/#{stage}"
      utopian_name = utopian_db_name(server, app, stage)
      debug "----------------------------- #{app.to_s.ljust(10, " ")} #{stage.to_s.ljust(10, " ")} ----------------------------"
      # update and make sure this app is supposed to go on this server
      if repo == '' || %x[git ls-remote #{repo} #{server}.#{stage}] == ''
        debug "[WRN] Skipping installation of #{app} on #{server} since no #{server}.#{stage} branch found"
        next
      end
=begin
      if !utopian && legacy_db_name(server, app, stage).nil?
        debug "[WRN] Skipping installation of #{app} on #{server} since no legacy db name found"
        next
      end
=end
      new_cap server, app, stage, utopian

      # deploy
      server_moonshine_folder = "#{app_root}/config/deploy/#{server}"
      stage_moonshine_file = "#{server_moonshine_folder}/#{stage}_moonshine.yml"
      if first_app && ENV['skipsetup'] != 'true'
        run_cap cap_stage, "deploy:setup"
        first_app = false
      elsif first
        run_cap cap_stage, "moonshine:setup_directories"
        first = false
      end

      # copy the database file
      #@cap_config.set(:shared_config, (@cap_config.fetch(:shared_configs, []) + [ "config/database.yml", "config/database.#{utopian_name}.yml", "config/moonshine.yml" ]).uniq)
      @cap_config.set(:shared_config, (@cap_config.fetch(:shared_configs, []) + [ "config/database.yml", "config/moonshine.yml" ]).uniq)
      if utopian
        db_file = File.read(File.join(MOONSHINE_MULTISITE_ROOT, "/assets/public/database_configs/database.#{utopian_name}.yml"))
      else
        db_file = File.read(Rails.root.join("/app/manifests/assets/private/database_configs/database.#{utopian_name}.yml"))
      end
      @cap_config.put db_file, "#{@cap_config.fetch(:shared_path)}/config/database.yml"
      @cap_config.put YAML::dump(@cap_config.fetch(:moonshine_config)), "#{@cap_config.fetch(:shared_path)}/config/moonshine.yml"
      puts "REPO BEFORE DEPLOY IS #{@cap_config.fetch(:repository)}"
      run_cap cap_stage, "deploy"
      run_cap cap_stage, "shared_config:symlink"

      # upload certs if possible

=begin
      # run the appropriate database setup command
      if database_mode == :nothing
        # create only
        run_rake_remotely "pulse:create:c4c:all"
        run_rake_remotely "pulse:create:c4c:all:utopian"
      elsif database_mode == :mirror
        # cap <db_source> pull:<pat>:to:<db_source>
        puts "cap #{db_source} pull:#{app}:to:#{db_source}#{":utopian" if utopian}"
      elsif database_mode == :seed
        puts "cap #{db_source} pull:#{app}:to:#{server}#{":utopian" if utopian}"
      end
=end
    end
  end
end

def root_config
  return @root_config if @root_config
  file_plugin = File.join(File.dirname(__FILE__), '..', 'config', 'database_root.yml')
  file_root = File.join(File.dirname(__FILE__), '/../../../../', 'config', 'database_root.yml')
  #file_root = File.join(Rails.root.join('config', 'database_root.yml'))
  if File.exists?(file_plugin)
    file_found = file_plugin
  elsif File.exists?(file_root)
    file_found = file_root
  end

  if file_found
    @root_config = {'database' => nil}.merge(YAML::load(File.open(file_found)))
  else
    throw %|
Aborting. Need a config/database_root.yml file with contents as arguments for
ActiveRecord::Base.establish_connection.

--- 
:host: localhost
:adapter: mysql
:username: username
:password: password

The user given must have access to create and destroy databases.|
  end
end

def load_dump(dump, db)
  throw "Overwriting production database detected! db: #{db}" if %w(summerprojecttool emu ciministry).include?(db.to_s)
  execute_sql "DROP DATABASE IF EXISTS #{db}; CREATE DATABASE #{db}"
  output_command = Kernel.is_windows? ? 'type' : 'cat'
  username = root_config[:username]
  password = root_config[:password]
  execute_shell "#{output_command} #{dump} | mysql --user #{username} #{db} --password=#{password}"
end

# expects
#
# :prod => <name of production database>
# :dev => <name of development database to copy prod to> OR 
#         :file filename string, to dump to in tmp dir
## production will be clone to development
# 
def clone(params)
  prod = params[:prod]
  dev = params[:dev]
  file = params[:file]
  dbserver = root_config[:host]
  dbuser = root_config[:username]
  dbpass = root_config[:password]

  throw "need a :prod database" unless prod.present?
  throw "need a :dev database" unless dev.present? || file.present?

  password = root_config['password']
  options = "--extended-insert --skip-lock-tables --skip-add-locks  --skip-set-charset --skip-disable-keys"

  if file
    dest = "| gzip > #{Rails.root.join(file)}"
  else
    dest = "| mysql -h #{dbserver} -u #{dbuser} --password=#{dbpass} #{dev}"
    unless @databases && @databases.include?(dev)
      ActiveRecord::Base.connection.create_database(dev)
    end
  end
  execute_shell "mysqldump #{options} -h #{dbserver} -u #{dbuser} --password=#{dbpass} #{prod} | sed \"2 s/.*/SET SESSION sql_mode='NO_AUTO_VALUE_ON_ZERO';/\" #{dest}"
end

def prepare_for_sql
  unless defined?(ActiveRecord) && @sql
    require "active_record"
    root_config
    ActiveRecord::Base.establish_connection root_config.merge('database' => '')
  end

  # grab a connection if there's not one already
  unless @sql
    @sql = ActiveRecord::Base.connection
  end
end

def execute_sql(command)
  prepare_for_sql

  for c in command.split(';')
    puts "[SQL] #{c.lstrip.rstrip}"
    @sql.execute c
  end
end

def select_rows(command)
  prepare_for_sql
  ActiveRecord::Base.connection.select_rows(command)
end

def execute_shell(command)
  puts "[SH ] #{command}"
  system command
end

def for_dbs(action)
  multisite_config_hash[:apps].keys.each do |app|
    namespace app do
      namespace action do
        multisite_config_hash[:servers].keys.each do |server|
          namespace server do
            multisite_config_hash[:stages].each do |stage|
              utopian = utopian_db_name(server, app, stage)
              legacy = legacy_db_name(server, app, stage)
              master_utopian = utopian_db_name(server, app, @master_stage)
              master_legacy = legacy_db_name(server, app, @master_stage)
              yield :server => server, :app => app, :stage => stage,
                :utopian => utopian, :legacy => legacy,
                :master_utopian => master_utopian, :master_legacy => master_legacy
            end
          end
        end
      end
    end
  end
end

def query_databases
  begin
      @databases = select_rows('show databases').flatten
  rescue
  end
end

def debug(stmt)
  puts stmt
end


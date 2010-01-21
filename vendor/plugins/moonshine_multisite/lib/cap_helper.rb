require "#{File.dirname(__FILE__)}/rake_helper.rb"
require "#{File.dirname(__FILE__)}/detect_windows.rb"

def pull_db(app, server, stage, remote_db, local_db)
  debug "[DBG] pull_db app=#{app} server=#{server} stage=#{stage} remote_db=#{remote_db} local_db=#{local_db}"
  run_remote_utility_rake "#{app}:dump:#{server}:#{stage}"
  utopian = utopian_db_name(server, app, stage)
  local_dump_path = "tmp/#{utopian}.sql".gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
  remote_dump_path = "#{fetch(:utility)}/tmp/#{utopian}.sql"
  download remote_dump_path+'.gz', local_dump_path+'.gz' 
  gunzip = Kernel.is_windows? ? File.join(File.dirname(__FILE__), '..', 'windows', 'gzip', 'gunzip.exe') : 'gunzip'
  execute_shell "#{gunzip} #{local_dump_path}.gz -f"
  load_dump local_dump_path, local_db
end

# helper task to run rake commands remotely
def run_remote_utility_rake(rake_cmd)
  run_remote_rake rake_cmd, fetch(:utility)
end

# helper task to run rake commands remotely
def run_remote_rake(rake_cmd, path = current_path, cap_config = self)
  rake = cap_config.fetch(:rake, "rake")
  rails_env = cap_config.fetch(:rails_env, "production")
  puts "[RUN] cd #{path} && #{rake} RAILS_ENV=#{rails_env} #{rake_cmd.split(',').join(' ')}"
  cap_config.run "cd #{path} && #{rake} RAILS_ENV=#{rails_env} #{rake_cmd.split(',').join(' ')}"
end

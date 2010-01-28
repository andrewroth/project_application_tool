require 'yaml'
require 'erb'

def utopian_db_name(server, app, stage)
  "#{server || 'server'}_#{app || 'app'}_#{stage || 'stage'}"
end

def legacy_db_name(server, app, stage)
  #debug "[DBG] legacy_db_name server=#{server} app=#{app} stage=#{stage}"
  hash_path = [ :servers, server.to_sym, :stage_moonshines, app.to_sym, stage.to_sym, :db_name ]
  traverse_hash(multisite_config_hash, hash_path)
end

def traverse_hash(hash, hash_path)
  path_so_far = hash
  for next_segment in hash_path
    if path_so_far[next_segment]
      path_so_far = path_so_far[next_segment]
    else
      return nil
    end
  end
  return path_so_far
end

def multisite_config_hash
  return @multisite_config if @multisite_config
  file = "#{File.dirname(__FILE__)}/../moonshine_multisite.yml"
  return {} unless File.exists?(file)
  @multisite_config = YAML.load(ERB.new(File.read(file)).result)
end

# Sets the key and values in capistrano from the moonshine multisite config
# Also sets @moonshine_config as a hash of moonshine values (similar to what
# would be gotten from a moonshine.yml)
def apply_moonshine_multisite_config(server, app, stage)
  server = server.to_sym
  stage = stage.to_sym unless stage.nil?

  debug "[DBG] apply_moonshine_multisite_config server=#{server} app=#{app} stage=#{stage}"
  return false if multisite_config_hash[:servers][server.to_sym].nil?
  
  @moonshine_config = { :application => app }
  @moonshine_config.merge!(traverse_hash(multisite_config_hash, [ :servers, server, :moonshine ]) || {})
  puts "utopian override: #{fetch(:utopian_override, false)}"
  if fetch(:utopian_override, false)
    @moonshine_config.merge!(traverse_hash(multisite_config_hash, [ :servers, server, :local, :moonshine ]) || {})
    puts traverse_hash(multisite_config_hash, [ :servers, server, :local, :moonshine ]).inspect
    @moonshine_config.merge!(traverse_hash(multisite_config_hash, [ :servers, server, :local, :stage_moonshines, app, stage ]) || {})
  else
    @moonshine_config.merge!(traverse_hash(multisite_config_hash, [ :servers, server, :stage_moonshines, app, stage ]) || {})
  end

  # useful to know the server and stage later on
  @moonshine_config[:server_only] = server
  @moonshine_config[:stage_only] = stage

  # give some defaults
  @moonshine_config[:repository] ||= multisite_config_hash[:apps][app]
  @moonshine_config[:repository] ||= (@moonshine_config[:repository] =~ /^svn/ ? :svn : :git)
  @moonshine_config[:branch] ||= (stage ? "#{server}.#{stage}" : nil)
  if @moonshine_config[:server_name]
    @moonshine_config[:deploy_to] ||= "/var/www/#{@moonshine_config[:server_name]}"
  else
    if stage == multisite_config_hash[:stages].first
      @moonshine_config[:deploy_to] ||= "/var/www/#{app}.#{@moonshine_config[:domain]}"
    else
      @moonshine_config[:deploy_to] ||= "/var/www/#{app}.#{stage}.#{@moonshine_config[:domain]}"
    end
  end

  # allow overriding from env
  @moonshine_config.each do |key, value|
    if ENV[key.to_s]
      case ENV[key.to_s]
      when 'true'
        env_value = true
      when 'false'
        env_value = false
      else
        env_value = ENV[key.to_s]
      end

      @moonshine_config[key] = env_value
    end
  end

  # set cap values
  @moonshine_config.each do |key, value|
    set(key.to_sym, ENV[key.to_s] || value)
  end

  set(:moonshine_config, @moonshine_config)

  puts @moonshine_config.inspect
  return true
end

 # Sets the key and values in capistrano from the moonshine multisite config
# Also sets @moonshine_config as a hash of moonshine values (similar to what
# would be gotten from a moonshine.yml)
def apply_moonshine_multisite_config2(server, stage)
  debug "[DBG] apply_moonshine_multisite_config server=#{server} stage=#{stage}"
  return false if multisite_config_hash[:servers][server.to_sym].nil?
  domain = multisite_config_hash[:servers][server.to_sym][:domain]
  # give some nice defaults
  @moonshine_config = {
    :application => fetch(:application), # needs to be in @moonshine_config to be uploaded
    :server_only => server,
    :repository => multisite_config_hash[:apps][fetch(:application).to_sym],
    :scm => if (!! repository =~ /^svn/) then :svn else :git end,
    :branch => (stage ? "#{server}.#{stage}" : nil)
  }
  @moonshine_config.merge! multisite_config_hash[:servers][server.to_sym]
  # allow overriding from env
  @moonshine_config.each do |key, value|
    if ENV[key.to_s]
      case ENV[key.to_s]
      when 'true'
        env_value = true
      when 'false'
        env_value = false
      else
        env_value = ENV[key.to_s]
      end

      @moonshine_config[key] = env_value
    end
  end

  # TODO: figure out why I need to do these next lines, after the defaults again.... :S
  #   I think it was getting overridden somehow.. but I don't know where I was seeing it.
  @moonshine_config.merge!({
    # TODO: switch everything in the config to symbols
    :deploy_to => "/var/www/#{fetch(:application)}.#{stage}.#{@moonshine_config['domain']}",
  })
  # tie the multisite_config_hash back to the instance variabled one
  multisite_config_hash[:servers][server.to_sym] = @moonshine_config
  @moonshine_config.each do |key, value|
    set(key.to_sym, ENV[key.to_s] || value)
  end
  if stage
    # don't set any stage unless given, to give error on tasks that should have it
    @moonshine_config[:stage_only] = stage
    set :stage_only, stage
  end
  set :server_only, server
  set :moonshine_config, @moonshine_config
  return true
end

# Assumes that your capistrano-ext stages are actually in "host/stage", then
# extracts the host and stage and goes to apply_moonshine_multisite_config
def apply_moonshine_multisite_config_from_cap
  if fetch(:stage).to_s =~ /(.*)\/(.*)/
    apply_moonshine_multisite_config $1, fetch(:application), $2
  elsif fetch(:stage).to_s =~ /(.+)/
    apply_moonshine_multisite_config $1, fetch(:application), nil
  end
end

def get_stages
  multisite_config_hash[:servers].keys.collect { |host|
    multisite_config_hash[:stages].collect{ |stage|
      [ "#{host}/#{stage}", "#{host}" ]
    }
  }.flatten + (multisite_config_hash[:legacy_stages].collect(&:to_s) || [])
end

def set_stages
  set :stages, get_stages
end

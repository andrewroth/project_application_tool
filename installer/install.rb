require 'erb'

RUBYGEMS_URL  = "http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz"
RUBY_EE_URL   = "http://rubyforge.org/frs/download.php/41040/ruby-enterprise-1.8.6-20080810.tar.gz"

Dir.chdir('installer')

def decision(m)
  printf "#{m} (Y/n) "
  return gets.chomp != 'n'
end

def confirm
  printf "Continue? (Y)es/(s)kip "
  c = gets.chomp

  return c != 's'
end
  
def find(f)
  !%x[which #{f}].empty?
end

puts %|
This PAT installer requires a debian system.

It will install apache2 using apt.
It will use mod_rails to run the PAT.

PAT files will go in /var/www/{name_of_domain}

You will be prompted along the way for various options.

|
abort unless decision('Continue?')

def run(cmd)
  puts "\nRun> #{cmd}"
  go = confirm
  if go then
    system cmd
  else puts('skipped command')
  end
end

puts ""
printf "Looking for rubygems.. "

found_gem = find('gem')
found_gem1_8 = find('gem1.8')

# rubygems
if !found_gem && !found_gem1_8
  puts "not found"
  tgz_name = File.basename(RUBYGEMS_URL)
  tgz_expanded_name = tgz_name[0,tgz_name.length-4]
  run "wget #{RUBYGEMS_URL}" unless File.exists?(tgz_name)
  run "tar vxfz #{tgz_name}" unless File.exists?(tgz_expanded_name)
  run "cd #{tgz_expanded_name}; ruby setup.rb --no-rdoc --no-ri"
else
  puts %|found
     Note: It is recommended that rubygems be installed from tarball 
           since the debian package is quite old|
end

found_gem = find('gem')
found_gem1_8 = find('gem1.8')
if !found_gem && found_gem1_8
  puts "found gem1.8 but not gem, make ln"
  run "ln -s /usr/bin/gem1.8 /usr/bin/gem"
end

# apache2
printf "Looking for apache2.. "
unless find('apache2')
  puts 'not found'
  run "apt-get install apache2 apache2-utils"
else puts('found')
end

# gems -- note passenger depends on having apache2
required_gems = %w(rdoc rails passenger capistrano soap4r)
puts ""
puts "Looking for required gems: #{required_gems.join(', ')}"
for gem in required_gems
  found_gem = %x[gem list -i #{gem}].chomp == 'true'
  run "gem install #{gem}" unless found_gem
end

# setup passenger
printf "Looking for passenger mod_rails.. "
apache2_conf = "/etc/apache2/apache2.conf"
if %x[grep Passenger #{apache2_conf}].empty?
  puts "not found, installing"
  run "apt-get install libopenssl-ruby apache2-prefork-dev"
  run "passenger-install-apache2-module"

  append = decision("\nDo you want to append\n" + 
               "#{File.read('passenger_apache2')}\nto #{apache2_conf}?")
  run "cat passenger_apache2 >> /etc/apache2/apache2.conf" if append
else puts "found"
end

# ruby ee
printf "Looking for ruby ee.. "
if Dir['/opt/*'].empty?
  puts "not found"
  run "apt-get install zlib1g-dev libssl-dev"
  ee_name = File.basename(RUBY_EE_URL)
  ee_expanded_name = ee_name[0,ee_name.length-'.tar.gz'.length]
  run "wget #{RUBY_EE_URL}" unless File.exists?(ee_name)
  run "tar vxfz #{ee_name}" unless File.exists?(ee_expanded_name)
  run "cd #{ee_expanded_name}; ./installer"
else puts "found"
end

# use the latest passenger install in apache2.conf
printf "Looking for ruby ee line in apache2.conf.. "
ruby_ee_path = Dir['/opt/*'].sort.last
ruby_ee_line = "PassengerRuby #{ruby_ee_path}/bin/ruby"
if %x[grep PassengerRuby /etc/apache2/apache2.conf | grep opt].empty?
  puts "not found"
  append = decision("\nDo you want to append\n" + 
               "    #{ruby_ee_line}\nto #{apache2_conf}?")
  run "echo '#{ruby_ee_line}' >> /etc/apache2/apache2.conf" if append
else puts "found"
end

# gems -- note passenger depends on having apache2
required_gems = %w(soap4r)
puts ""
puts "Looking for ruby ee required gems: #{required_gems.join(', ')}"
for gem in required_gems
  found_gem = !%x[#{ruby_ee_path}/bin/gem list --local | grep #{gem}].empty? # -i doesn't work?
  run "#{ruby_ee_path}/bin/gem install #{gem}" unless found_gem
end

# install sites
printf "\n\nWhat is your domain (ex site.com)? "
domain = gets.chomp

config = {
  # TODO - a default setting for using localhost
}

if domain == 'powertochange.org' || true
  settings = { :adapter => 'mysql', :host => 'dbserver.powertochange.local', :user => 'ciministry' }
  override = { 
    'pat' => {
      :settings => settings, 
      :dbs => { :production => 'summerprojecttool', :test => 'spt_test',
                :ciministry_production => 'ciministry',
                :authservice_production => 'authservice_production'
              },
      :env => 'production'
    },
    'dev.pat' => {
      :settings => settings, 
      :dbs => { :development => 'spt_dev', :test => 'spt_test',
                :ciministry_development => 'dev_campusforchrist',
                :authservice_development => 'authservice_development'
              },
      :env => 'development'
    },
    'demo.pat' => {
      :settings => settings, 
      :dbs => { :production => 'demo_pat',
                :ciministry_production => 'demo_campusforchrist',
                :authservice_production => 'demo_authservice'
              },
      :env => 'production'
    }
  }

  puts "\nFound special settings for your domain:"
  puts override.inspect
  if decision("Do you want to use them?") then config = override end
end

def sub(f)
  template = ERB.new(File.read(f), nil, '<>')
  template.result
end

def confirm_overwrite(p)
  if File.exists? p
    write = decision("File #{p} already exists, overwrite?")
  else write = true
  end

  write(p) do |f| yield(f) end
end

def write(p)
  f = File.open(p, 'w')
  yield f
  f.close
end

def ensure_dir_exists(p)
  run "mkdir #{p}" unless File.exists?(p)
end

ensure_dir_exists "/var/www"

for prefix, options in config
  site = "#{prefix}.#{domain}"

  puts "\nSetup #{site}"
  ensure_dir_exists "/var/www/#{site}"
  ensure_dir_exists "/var/www/#{site}/shared"
  ensure_dir_exists "/var/www/#{site}/shared/log"

  config_path = "/etc/apache2/sites-available/#{site}"
  confirm_overwrite(config_path) do |f|
    # generate the config file for apache2
    @site = site
    @env = options[:env]

    f.write(sub('apache_config.erb'))
    run "ln -s /etc/apache2/sites-available/#{site} /etc/apache2/sites-enabled/#{site}" unless
      File.exists?("/etc/apache2/sites-enabled/#{site}")
  end

  database_yml_path = "/var/www/#{site}/database.yml"
  confirm_overwrite(database_yml_path) do |f|
    # generate the database.yml file
    @settings, @dbs = options[:settings], options[:dbs]

    # get pass from user so we don't have passwords in svn
    printf "What's the password for db access to #{site}? "
    @settings[:pass] = gets.chomp

    f.write(sub('database.yml.erb'))
  end
end

# need sshd so cap deploys work
printf "checking for sshd so that cap deploys work.. "
if %x[which sshd].empty?
  puts "not found"
  run "apt-get install openssh-server"
else puts 'found'
end

# need a user in www-data group
printf "\nwhat user will be used to do deploys? "
user = gets.chomp
run "usermod -G www-data #{user}; chmod g+rw /var/www -R; chown www-data.www-data /var/www -R"

# check out the source and do one deploy to get it in there
unless File.exists? 'pat'
  puts "need to check out the source code once so that cap deploys can be run."
  puts "this may take a few minutes.."
  puts
  run "svn co https://svn.ministryapp.com/pat/trunk pat"
else
  run "svn up pat/config/deploy.rb"
end

Dir.chdir('pat')
for prefix, options in config
  rails_env = options[:env]
  deploy_to = "/var/www/#{prefix}.#{domain}"
  run "cap deploy host=127.0.0.1 user=#{user} deploy_to=#{deploy_to} env=#{rails_env}"
end

# TODO: make it install a clean version of mysql

# restart apache to get it to pick up the new rails domains
run "/etc/init.d/apache2 restart"

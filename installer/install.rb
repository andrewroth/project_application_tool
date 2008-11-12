require 'erb'

RUBYGEMS_URL = "http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz"
FUSION_URL   = "http://rubyforge.org/frs/download.php/41040/ruby-enterprise-1.8.6-20080810.tar.gz"
RUBY_EE_URL  = "http://rubyforge.org/frs/download.php/41040/ruby-enterprise-1.8.6-20080810.tar.gz"

Dir.chdir('installer')

def confirm
  printf 'Continue? (y/n) '
  c = gets.chomp
  abort unless c == 'y'
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
confirm

def run(cmd)
  puts "\nRun> #{cmd}"
  confirm
  system cmd
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
elsif !found_gem1_8
  puts "found gem1.8 but not gem, make ln"
  run "ln -s /usr/bin/gem1.8 /usr/bin/gem"
else
  puts %|found
     Note: It is recommended that rubygems be installed from tarball 
           since the debian package is quite old|
end

# apache2
printf "Looking for apache2.. "
unless find('apache2')
  puts 'not found'
  run "apt-get install apache2 apache2-utils"
else puts('found')
end

# gems -- passenger depends on having apache2
required_gems = %w(rdoc rails passenger capistrano)
puts ""
puts "Installing required gems: #{required_gems.join(', ')}"
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

  printf "\nDo you want to append\n#{File.read('passenger_apache2')}\nto #{apache2_conf}? (y/n) "
  a = gets.chomp
  run "cat passenger_apache2 >> /etc/apache2/apache2.conf" if a == 'y'
end

# ruby ee
if Dir['/opt/*'].empty?
  run "apt-get install zlib1g-dev libssl-dev"
  ee_name = File.basename(RUBY_EE_URL)
  ee_expanded_name = ee_name[0,ee_name.length-'.tar.gz'.length]
  run "wget #{RUBY_EE_URL}" unless File.exists?(ee_name)
  run "tar vxfz #{ee_name}" unless File.exists?(ee_expanded_name)
  run "cd #{ee_expanded_name}; ./installer"
end

# use the latest passenger install
ruby_ee_path = Dir['/opt/*'].sort.last
@ruby_ee_line = "PassengerRuby #{ruby_ee_path}/bin/ruby"

# install sites
printf "\nWhat is your domain (ex site.com)? "
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
  printf "Do you want to use them? (y/n) "
  confirm = gets.chomp

  if confirm == 'y' then config = override end
end

def sub(f)
  template = ERB.new(File.read(f), nil, '<>')
  template.result
end

def confirm_overwrite(p)
  if File.exists? p
    printf "File #{p} already exists, overwrite? (y/n) "
    write = gets.chomp == 'y'
  else write = true
  end

  write(p) do |f| yield(f) end
end

def write(p)
  f = File.open(p, 'w')
  yield f
  f.close
end

for prefix, options in config
  site = "#{prefix}.#{domain}"

  puts "Setup #{site}"
  run "mkdir /var/www/#{site}" unless File.exists?("/var/www/#{site}")

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
    @settings[:pass] = 'password' # stub

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
printf "what user will be used to do deploys? "
user = gets.chomp
run "usermod -G www-data #{user}"
run "chmod g+rw /var/www -R"

# check out the source and do one deploy to get it in there
run "svn co https://svn.ministryapp.com/pat/trunk pat" unless File.exists?('pat')
Dir.chdir('pat')
run "cap deploy host=127.0.0.1 port=22 user=#{user}"

# TODO: make it install a clean version of mysql

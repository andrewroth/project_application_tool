FUSION_URL   = "http://rubyforge.org/frs/download.php/41040/ruby-enterprise-1.8.6-20080810.tar.gz"
RUBYGEMS_URL = "http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz"

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
  run "wget #{RUBYGEMS_URL}" unless File.exists?('rubygems-1.3.1.tgz')
  run "tar vxfz rubygems-1.3.1.tgz" unless File.exists?('rubygems-1.3.1')
  run "cd rubygems-1.3.1; ruby setup.rb --no-rdoc --no-ri"
elsif !found_gem1_8
  puts "found gem1.8 but not gem, make ln"
  run "ln -s /usr/bin/gem1.8 /usr/bin/gem"
else puts "found (Note: It is recommended that rubygems be installed from tarball since the debian package is quite old"
end

# apache2
printf "Looking for apache2.. "
unless find('apache2')
  puts 'not found'
  run "apt-get install apache2 apache2-utils"
else puts('found')
end

# gems -- passenger depends on having apache2
required_gems = %w(rdoc rails passenger)
puts ""
puts "Installing required gems: #{required_gems.join(', ')}"
for gem in required_gems
  found_gem = %x[gem list -i #{gem}].chomp == 'true'
  run "gem install #{gem}" unless found_gem
end

# fusion


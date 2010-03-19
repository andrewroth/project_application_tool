def pull_assets(remote, local)
  run "tar -czf #{remote}.tar.gz #{remote}"
  download "#{remote}.tar.gz", "#{local}.tar.gz"
  puts "tar -xfz #{local}.tar.gz"
  system "tar xfz #{local}.tar.gz"
end

task :pull_assets do
  set :user, 'deploy'
  set :host, 'pat.powertochange.org'

  pull_assets '/var/www/pat.powertochange.org/shared/public/event_groups',
    '/var/www/pat.powertochange.org/shared/public/event_groups'
end


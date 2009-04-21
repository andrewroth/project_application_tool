desc "Task to do some preparations for CruiseControl"
task :prepare do
  RAILS_ENV = 'test'
end

desc "Task for CruiseControl.rb"
task :cruise => ["prepare", "db:test:clone", "spec"] do
end


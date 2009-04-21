desc "Task to do some preparations for CruiseControl"
task :prepare do
  RAILS_ENV = 'test'
end

desc "Task for CruiseControl.rb"
task :cruise => ["prepare", "db:test:clone", "spec:rcov"] do
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  # show code coverage in results
  mv 'coverage', "#{out}/coverage" if out
end


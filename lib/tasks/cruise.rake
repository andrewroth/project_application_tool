desc "Task to do some preparations for CruiseControl"
task :prepare do
  RAILS_ENV = 'test'
  ENV['RUBYOPT'] = 'rubygems'
end

desc "Task for CruiseControl.rb"
task :cruise => ["prepare"] do

  # we want code coverage artifact regardless of the build spec result
  begin
    Rake::Task["spec:rcov"].invoke
  rescue Exception => e
  end

  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  # show code coverage in results
  mv 'coverage', "#{out}/coverage" if out

  raise e if e
end


# support a command line option --rcov_baseline which will load in all models and controllers, 
# so that rcov has a baseline of all the files (roughly) that are used.
if ARGV.include?('--rcov_baseline')
  puts "Loading each controller and model once to get the base coverage in."

  # seems that we need application.rb loaded first for all the other controllers to work,
  # not sure why it doesn't automatically fine application.rb when it hits Application class
  require "#{RAILS_ROOT}/app/controllers/application_controller.rb"

  Dir["#{RAILS_ROOT}/app/models/*.rb", "#{RAILS_ROOT}/app/controllers/*.rb"].each do |file|
      require file
  end
end


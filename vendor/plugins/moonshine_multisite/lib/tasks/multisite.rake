require "yaml"
require "#{File.dirname(__FILE__)}/../../lib/multisite_helper.rb"

namespace :moonshine do
  namespace :multisite do
    namespace :copy do
      desc "copies everything in app/manifests/assets/public/database_configs to config"
      task :database_configs do
        Dir["app/manifests/assets/public/database_configs/*.yml"].each do |file|
          dest = "config/#{File.basename(file)}"
          if File.exists? dest
            puts "skipping existing file '#{dest}'"
          else
            File.copy file, "config/#{File.basename(file)}"
          end
        end
      end
    end
  end
end

require 'find'
require 'ftools'

namespace :db do
  namespace :fixtures do
    desc 'Dumps all models into spec/fixtures.'
    task :dump => :environment do
      models = []
      Find.find(RAILS_ROOT + '/app/models', 
                RAILS_ROOT + '/vendor/plugins/common_models/app/models') do |path|
        next if path['svn'] || path.downcase['mailer']
        unless File.directory?(path) then models << path.match(/(\w+).rb/)[1] end
      end
  
      puts "Found models: " + models.join(', ')
      
      fixtures_base = '/spec/fixtures'

      models.each do |m|
        begin
          puts "Dumping model: " + m
          model = m.camelize.constantize
          next if model.abstract_class

          entries = model.find(:all, :order => "#{model.primary_key} ASC")

          formatted, increment, tab = '', 1, '  '
          entries.each do |a|
            formatted += m + '_' + increment.to_s + ':' + "\n"
            increment += 1

            a.attributes.each do |column, value|
              formatted += tab

              match = value.to_s.match(/\n/)
              if match
                formatted += column + ': |' + "\n"

                value.to_a.each do |v|
                  formatted += tab + tab + v
                end
              else
                formatted += column + ': ' + value.to_s
              end

              formatted += "\n"
            end

            formatted += "\n"
          end

          table_name = if model.table_name['.']
              model.table_name =~ /\.(.*)/
              $1
            else
              model.table_name
            end

          model_file = RAILS_ROOT + fixtures_base + '/' + table_name + '.yml'

          File.exists?(model_file) ? File.delete(model_file) : nil
          File.open(model_file, 'w') {|f| f << formatted}
        rescue
          puts "skipping #{m}"
        end
      end
    end

    desc 'Dumps all test models into spec/fixtures.'
    task :dump_test => :environment do
      # backup old one
      File.copy RAILS_ROOT + '/spec/fixtures', RAILS_ROOT + '/spec/fixtures.backup'

      # get rid of old fixtures
      system "svn del #{RAILS_ROOT}/spec/fixtures/*"
      
      # switch to test environment
      RAILS_ENV = 'test'
      ActiveRecord::Base.establish_connection(:test)
      
      # dump
      Rake::Task["db:fixtures:dump"].invoke

      # add the new ones and commit
      system "svn add #{RAILS_ROOT}/spec/fixtures/*"
      #system "svn commit -m 'auto generated fixtures'"
    end
 
  end
end

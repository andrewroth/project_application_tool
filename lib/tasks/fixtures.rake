posn = {}
posn["accountadmin_viewer.yml"] = 0

namespace "db:fixtures" do
  
  task :load_spt_info do
    puts "\nSPT -- NOTE\n" + 
    "Because fixtures define some global variables to " +
    "make looking up IDs easier, there is a required load order.\n" + 
    "Use db:fixtures:load:spt to load fixtures to rails env db or\n" + 
    "    db:fixtures:load:spt:test to load to the test db.\n\n"
  end
  
  task :load => :load_spt_info do
  end
  
  namespace "load" do
    
    desc "loads the fixtures into the test db"
    namespace :spt do
      task :test do
        re = RAILS_ENV
        RAILS_ENV = 'test'
        Rake::Task["db:fixtures:load:spt"].invoke
        RAILS_ENV = re
      end
    end
    
    desc "loads the fixtures into the database defined by the current rails environment"
    task :spt => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      files = (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : 
        (Dir.glob(File.join('test', 'fixtures', '*.{yml,csv}')) +
        Dir.glob(File.join('test', 'fixtures', 'ciministry', '*.{yml,csv}')) +
        Dir.glob(File.join('test', 'fixtures', 'questionnaire_engine', '*.{yml,csv}'))))

      files.sort!{ |a,b| 
        pa = posn[File.basename(a)]
        pb = posn[File.basename(b)]
        if (pa.nil? && pb.nil?)
          a <=> b
        elsif (pa.nil? && !pb.nil?)
          1
        elsif (!pa.nil? && pb.nil?)
          -1
        else
          pa <=> pb
        end
      }
      
      files.each do |fixture_file|
          Fixtures.create_fixtures('./', fixture_file.gsub('.yml', '').gsub('.csv', ''))
      end
    end
  end
end


namespace :db do
  namespace :setup do
    desc "Setup for the pat, to be run while installing.  Loads all schemas in db/schema* and installs some required database rows (ex default user)."
    task :pat => :environment do
=begin
      def adapter() ActiveRecord::Base.configurations[RAILS_ENV]['adapter'] end
      def dbfile() ActiveRecord::Base.configurations[RAILS_ENV]['dbfile'] end

      if (adapter == 'sqlite' || adapter == 'sqlite3') && File.exist?(dbfile)
        puts "Hey, looks like there's already a database at #{dbfile}.  Do you want to delete this and start from scratch? (y/n)"
        ans = STDIN.gets.chomp.downcase
        reset = ans == 'y'
        
        if reset
          File.delete dbfile
        end
      end
=end

=begin
      # make sure to load schema_production last if it exists
      for schema in Dir.glob('db/schema*').sort{ |a,b| if a == 'schema_production.rb' then 1 elsif b == 'schema_production' then -1 else a <=> b end }
        puts "load #{schema}"
        load schema
      end
=end

      puts %|
1. cp config/database.proxy.yml config/database.yml

2. edit config/database/database.p2c_pat_prod.yml with your database info.

3. load the schemas with something like

      cat p2c_pat_prod.sql \| mysql --user root p2c_pat_prod
      cat c4c_intranet_prod.sql \| mysql --user root c4c_intranet_prod
      |

      # the spt expects two accessgroups 
      ag_pc = Accessgroup.find_or_create_by_accessgroup_key '[accessgroup_projects_coordinator]'
      ag_st = Accessgroup.find_or_create_by_accessgroup_key '[accessgroup_student]'
      ag_k1 = Accessgroup.find_or_create_by_accessgroup_key '[accessgroup_key1]'

      if EventGroup.find(:all).empty?
        @eg = EventGroup.create :title => "Default Event Group"
      end

      sql = ActiveRecord::Base.connection
      db = ActiveRecord::Base.configurations["ciministry_#{RAILS_ENV}"]['database']
      begin
        sql.execute "insert into #{db}.accountadmin_accountgroup (accountgroup_id, accountgroup_key, english_value) values (15, '[accountgroup_key15]', 'Unknown');"
      rescue
      end

      puts "Now run the PAT in another window, and log in.  Hit 'No' on the question about having logged in before.  Press enter once you've logged in."
      STDIN.gets

      ProjectsCoordinator.find_or_create_by_viewer_id Viewer.first.id

      puts "Great!  #{Viewer.first.person.name} now has projects coordinator access.  Reload the page."
    end
  end
end

def setup_demo
  puts 'in setup_demo'
  # project app
  #q = FormQuestionnaire.create :title => 'Project Application'
  #f = Form.create :name => 'Project Application', :questionnaire_id => q.id, :event_group_id => @eg.id, :hidden => false

  # reference app
  #q = FormQuestionnaire.create :title => 'Reference Application'
  #f = Form.create :name => 'Reference Application', :questionnaire_id => q.id, :event_group_id => @eg.id, :hidden => false
end


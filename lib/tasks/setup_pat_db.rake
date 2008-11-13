

namespace :db do
  namespace :setup => :environment do
    desc "Setup for the pat, to be run while installing.  Loads all schemas in db/schema* and installs some required database rows (ex default user)."
    task :pat do
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

      # make sure to load schema_production last if it exists
      for schema in Dir.glob('db/schema*').sort{ |a,b| if a == 'schema_production.rb' then 1 elsif b == 'schema_production' then -1 else a <=> b end }
        puts "load #{schema}"
        load schema
      end

      # the spt expects two accessgroups 
      ag_pc = Accessgroup.create :accessgroup_key => '[accessgroup_projects_coordinator]'
      ag_st = Accessgroup.create :accessgroup_key => '[accessgroup_student]'

      # now create a default ministry and default event group
      if Ministry.find(:all).empty?
        ministry = Ministry.create :name => "Default Ministry"
      end

      if EventGroup.find(:all).empty?
        @eg = EventGroup.create :ministry_id => ministry.id, :title => "Default Event Group"
      end

      # create default viewers, admin and student
      admin = Viewer.create :viewer_userID => 'admin', :viewer_passWord => '21232f297a57a5a743894a0e4a801fc3', :accountgroup_id => Accessgroup.find_by_accessgroup_key('[accessgroup_projects_coordinator]'), :viewer_lastLogin => 0
      student = Viewer.create :viewer_userID => 'student', :viewer_passWord => 'cd73502828457d15655bbd7a63fb0bc8', :accountgroup_id => Accessgroup.find_by_accessgroup_key('[accessgroup_student]'), :viewer_lastLogin => 0
      processor = Viewer.create :viewer_userID => 'processor', :viewer_passWord => 'cd73502828457d15655bbd7a63fb0bc8', :accountgroup_id => Accessgroup.find_by_accessgroup_key('[accessgroup_student]'), :viewer_lastLogin => 0

      # need people models
      p = Person.create :person_fname => 'John', :person_lname => 'Smith'
      Access.create :viewer_id => student.id, :person_id => p.id

      p = Person.create :person_fname => 'Ted', :person_lname => 'Jones'
      Access.create :viewer_id => processor.id, :person_id => p.id

      p = Person.create :person_fname => 'David', :person_lname => 'Robinson'
      Access.create :viewer_id => admin.id, :person_id => p.id

      # add them to their respective groups
      Vieweraccessgroup.create :viewer_id => admin.id, :accessgroup_id => ag_pc.id
      # Vieweraccessgroup.create :viewer_id => student.id, :accessgroup_id => ag_st.id
      
      setup_demo # optional, comment out by default
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


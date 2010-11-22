namespace :db do
  namespace :setup do
    desc "Setup for the pat, to be run while installing.  Loads all schemas in db/schema* and installs some required database rows (ex default user)."
    task :pat do

      puts %|
1. cp config/database.common.yml config/database.yml

2. cp config/database/database_header.yml.default config/database/database_header.yml and
    edit it with your database info.  Create databases if necessary.

TODO: Do we need instructions to get utopian_common_dev db set up?

3. run rake db:reset

4. run rake db:seed

Hit enter to continue once all this is done.
      |
      STDIN.gets

      # now that db load env
      Rake::Task["environment"].execute

      if EventGroup.find(:all).empty?
        @eg = EventGroup.create :title => "Default Event Group"
      end

      puts "Now run the PAT in another window, and log in.  Hit 'No' on the question about having logged in before.  Press enter once you've logged in."
      STDIN.gets

      v = Viewer.find ActiveRecord::SessionStore::Session.last.data[:user_id]
      ProjectsCoordinator.find_or_create_by_viewer_id v.id

      puts "Great!  #{v.person.name} now has projects coordinator access.  Reload the page."
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


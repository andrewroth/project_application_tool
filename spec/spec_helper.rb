# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
end

def setup_eg
  session[:event_group_id] = 1
  @eg = mock("eg", :empty? => false, :default_text_area_length => nil)
  EventGroup.stub!(:find).and_return(@eg)
end

def setup_form
  @form = mock("form", 
      :questionnaire => mock('questionnaire', :filter= => nil, :pages => []), 
      :event_group => @eg, 
      :title => 'a form'
  )
end

def setup_viewer
  session[:user_id] = 1

  @viewer = mock("viewer", {
    :project_director_projects => [],
    :project_administrator_projects => [],
    :support_coach_projects => [],
    :project_staff_projects => [],
    :processor_projects => [],
    :is_student? => false,
    :is_projects_coordinator? => false,
    :name => 'Bob'
  })

  Viewer.stub!(:find).with(1).and_return(@viewer)
end

FIXTURE_CLASS = {
  :cim_hrdb_campus => Campus,
  :accountadmin_viewer => Viewer,
  :cim_hrdb_person => Person,
  :cim_hrdb_assignment => Assignment,
  :cim_hrdb_assignmentstatus => Assignmentstatus,
}

def load_fixtures(*fixtures_array)
  set_fixture_class FIXTURE_CLASS
  fixtures fixtures_array
end

# use ruby-debug if installed
begin
  require 'ruby-debug'
rescue LoadError
end

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

def setup_login
  throw "mock_login needs to be done after @viewer and @event_group are set" unless @viewer && @event_group
  session[:cas_sent_to_gateway] = true # make cas think it's already gone to the server to avoid redirect
  session[:user_id] = @viewer.id
  session[:event_group_id] = @event_group.id
end

def mock_login() setup_login end

def mock_viewer_as_event_group_coordinator(params = {})
  mock_viewer({ :is_student? => false, :is_eventgroup_coordinator? => true, :is_projects_coordinator? => false }.merge(params))
end

def mock_viewer_as_projects_coordinator(params = {})
  mock_viewer({ :is_student? => false, :is_eventgroup_coordinator? => false, :is_projects_coordinator? => true }.merge(params))
end

def mock_viewer_as_staff(params = {})
  mock_viewer({ :is_student? => false, :is_eventgroup_coordinator? => false, :is_projects_coordinator? => false, 
              :is_project_administrator? => false, :is_project_director? => false,
              :set_project => true }.merge(params))
end

def mock_viewer(params = {})
  @viewer = mock_model(Viewer, { 
    :viewer_userID => 'copter', :viewer_passWord => '9cdfb439c7876e703e307864c9167a15', # password is lol
    :viewer_isActive= => 1, :viewer_lastLogin= => Time.now, :save! => '', :person => '', :name => 'Cop Ter',
    :profile_cost_items => []
  }.merge(params))
  Viewer.stub!(:find).and_return(@viewer)

  # tie-in with profile if possible
  if @profile
    @profile.stub!(:viewer => @viewer)
  end
end

def mock_event_group(params = {})
  @form = mock_model(Form)
  @event_group = mock_model(EventGroup, {
    :title => 'event_group', :empty? => false, :logo => "a", 
    :projects => (@project ? [ @project ] : [ ]), :prep_items => [],
    :forms => mock_ar_arr([@form], :find_by_hidden => @form)
  }.merge(params))
  EventGroup.stub!(:find).and_return(@event_group)
end

def mock_project(params = {})
  @project = mock_model(Project, { :title => 'project', :find_all_by_hidden => [@project], :collect => [], 
                        :all_cost_items => [], :prep_items => [] }.merge(params))

  # tie-in to what's already defined
  if @event_group
    @event_group.stub!(:projects => mock_ar_arr([ @project ], :find_all_by_hidden => [ @project ]))
    @project.stub!(:event_group => @event_group)
  end

  Project.stub!(:find).and_return(@project)
end

def mock_profile
  depends_on(:viewer)
  @profile = mock_model(Profile, :destroy => true, :viewer => @viewer, :viewer_id => @viewer.id,
                       :update_costing_total_cache => true)
  Profile.stub!(:find).and_return(@profile)
  Profile.stub!(:project).and_return(@project)
end

def mock_ar_arr(arr, extras = {})
  m = mock("ar_arr_#{arr.object_id}")
  m.__send__(:__mock_proxy).instance_eval <<-CODE
           def @target.set_arr(arr)
             @arr = arr
           end
           def @target.delete_all()
             @arr = []
           end
           def @target.method_missing(sym, *args, &block)
             @arr.send sym, *args, &block
           end
   CODE
  m.set_arr(arr)
  m.stub!(:reload => true)
  m.stub!(extras)
  return m
end

def depends_on(v)
  unless instance_variable_get("@#{v}")
    caller.first =~ /`(.*)'/
    raise "#{$1} requires @#{v} to be defined."
  end
end

def stub_viewer_as_staff(params = {}, person_params = {})
  stub_viewer_short params.merge(:st => true), person_params
end

def stub_viewer_as_event_group_coordinator(params = {}, person_params = {})
  stub_viewer_short params.merge(:egc => true), person_params
end

def stub_viewer_short(p = {}, person_params = {})
  full_params = {
    :project_director_projects => (p[:pd] ? [ @project ] : []),
    :project_administrator_projects => (p[:pa] ? [ @project ] : []),
    :support_coach_projects => (p[:sc] ? [ @project ] : []),
    :project_staff_projects => (p[:st] ? [ @project ] : []),
    :processor_projects => (p[:pr] ? [ @project ] : []),
    :is_eventgroup_coordinator? => p[:egc]
  }
  stub_viewer(full_params, person_params)
end

def stub_viewer(params = {}, person_params = {})
  person_params[:person_fname] ||= 'John'
  person_params[:person_lname] ||= 'Smith'
  @person = stub_model(Person, person_params)
  stub_model_find(:person)
  params[:person] ||= @person
  @viewer = stub_model(Viewer, params)
  stub_model_find(:viewer)
end

def stub_profile(params = {})
  @profile = stub_model(Profile, params)
  stub_model_find(:profile)
end

def stub_project(params = {})
  params[:title] ||= 'project_title'
  params[:event_group] ||= @event_group
  @project = stub_model(Project, params)
  @event_group.stub!(:projects => [ @project ])
  stub_model_find(:project)
end

def stub_event_group(params = {})
  params[:filename] ||= 'logo.png'
  params[:title] ||= 'event_group_title'
  @event_group = stub_model(EventGroup, params)
  EventGroup.stub!(:find).with(:all).and_return([ @event_group] )
  stub_model_find(:event_group)
end

def stub_model_find(v)
  inst = instance_variable_get("@#{v}")
  inst.class.stub!(:find).with(inst.id).and_return(inst)
  inst.class.stub!(:find).with(inst.id.to_s).and_return(inst)
  inst.class.stub!(:find).with([inst.id]).and_return(inst)
  inst.class.stub!(:find).with([inst.id.to_s]).and_return(inst)
end

FIXTURE_CLASS = {
  :cim_hrdb_campus => Campus,
  :accountadmin_viewer => Viewer,
  :cim_hrdb_person => Person,
  :cim_hrdb_assignment => Assignment,
  :cim_hrdb_assignmentstatus => Assignmentstatus,
} unless defined?(FIXTURE_CLASS)

def load_fixtures(*fixtures_array)
  set_fixture_class FIXTURE_CLASS
  fixtures fixtures_array
end

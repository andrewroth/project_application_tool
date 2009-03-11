require File.dirname(__FILE__) + '/../test_helper'

# this "test" class is really just to set up the db. The fixtures
# use global ruby values so there are dependencies, this test case
# will set them up in the right order
class SetupTestDb < Test::Unit::TestCase
  fixtures "questionnaire_engine/questionnaires"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_viewer"
  fixtures "ciministry/accountadmin_vieweraccessgroup"
  fixtures "ciministry/cim_hrdb_access"
  fixtures "ciministry/cim_hrdb_assignment"
  fixtures "ciministry/cim_hrdb_person"
  fixtures "ciministry/cim_hrdb_campus"
  fixtures "ciministry/spt_ticket"
  fixtures :applns, :projects, :forms, :processors

  def setup
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  # this is required to get the fixtures loaded
  def test_setup_db
  end
end

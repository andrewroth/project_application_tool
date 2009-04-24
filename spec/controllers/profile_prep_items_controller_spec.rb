require File.dirname(__FILE__) + '/../spec_helper'

describe ProfilePrepItemsController do

  before do 
    stub_viewer_as_event_group_coordinator
    stub_event_group
    stub_project
    setup_login
    
    @prep_item = stub_model(PrepItem)
    stub_model_find(:prep_item)
  end

  describe "valid profile prep item attributes" do
    
    before do
      stub_profile_prep_item
      stub_profile
      @params = { :id => @profile_prep_item.id }
    end
    
    it "should create new profile prep item" do
      ppi = stub_model(ProfilePrepItem)
      ProfilePrepItem.should_receive(:new).and_return(ppi)
      ppi.should_receive(:save).and_return(true)
      post 'create', :id => @profile.id, :profile_prep_item => @params
      assigns[:profile_prep_item].should_not be_nil
      assigns[:profile_prep_item].should_not be_new_record
      flash[:error].should be_nil
      flash[:notice].should_not be_nil
    end
        
    it "should update profile prep item" do
      @profile_prep_item.should_receive(:update).and_return(true)
      post 'update', :id => @profile_prep_item.id, :profile_prep_item => @params
      response.should be_success
    end
    
    it "should destroy profile prep item" do
      ProfilePrepItem.delete_all
      response.should be_success
    end
    
    it "should render index" do
      @profile.stub!(:all_prep_items => [ @prep_item ])
      @profile.stub!(:profile_prep_items => mock('results', 
                        :find_or_create_by_prep_item_id => @profile_prep_item))
      @profile_prep_item.should_receive(:save!)
      post 'index', :id => @profile.id
      response.should be_success
      response.should render_template('index')
    end
    
  end
  
  def stub_profile_prep_item
    @profile_prep_item = stub_model(ProfilePrepItem)
    stub_model_find(:profile_prep_item)
  end

  describe "with invalid params" do
  
    before do
      stub_profile_prep_item
      stub_profile
      @params = { }
    end
  
    it "should not create prep item with invalid params" do
      post 'create', :id => @profile.id, :profile_prep_item => @params
      response.should_not be_success
    end
  
    it "should not update profile prep item with invalid params" do
      @profile_prep_item.should_receive(:update).and_return(true)
      post 'update', :id => @profile_prep_item.id, :profile_prep_item => @params
    end
  
  end

end

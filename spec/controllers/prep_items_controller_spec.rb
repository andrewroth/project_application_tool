require File.dirname(__FILE__) + '/../spec_helper'

describe PrepItemsController do
  integrate_views
  fixtures :prep_items
  
  it "should redirect to index on successful save" do
    PrepItem.any_instance.stubs(:valid?).returns(true)
    post 'create'
    response.should redirect_to(prep_items_path)  
    assigns[:prep_item].should_not be_new_record
    flash[:notice].should be_nil
  
  end
  
  it "should render new template on failed save" do
    PrepItem.any_instance.stubs(:valid?).returns(false)
    post 'create'
    assigns[:prep_item].should be_new_record
    response.should render_template('new')
  end
  
  it "shoud pass prep item params" do
    post 'create', :prep_item => { :title => 'item', :description => 'not blank'}
    assigns[:prep_item].title.should == 'item'
    assigns[:prep_item].description.should == 'not_blank'
  end
  
end
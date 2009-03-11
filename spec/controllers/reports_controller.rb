require File.dirname(__FILE__) + '/../spec_helper'

describe ReportsController do

  it "should render registrants properly" do
    setup_viewer; setup_eg; setup_form

    @eg.stub!(:projects => [
       ],
       :has_your_campuses => false
    )

    @project1 = mock('project', :title => 'project1', :id => 1)
    @project2 = mock('project', :title => 'project2', :id => 2)

    Viewer.stub!(:find).with(1).and_return(@viewer)
    Viewer.stub!(:find).with(:all, :include => :persons).and_return( [
      stub('viewer1', 
        :person => mock('person'),
        :is_student? => true,
        :applns => mock('applns', :find => [ 
          mock('appln', 
            :id => 1,
            :form => @form,
            :preference1 => @project1, :preference1_id => @project1.id,
            :preference2 => @project2, :preference2_id => @project2.id
        ) ] )
      )
    ] )
    
    get :registrants, :project_id => 'all'

    assigns('rows').should_not be_nil
  end

end

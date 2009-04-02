require File.dirname(__FILE__) + '/../spec_helper'

describe ToolsController do

  def setup2
    @viewer.stub!(:is_eventgroup_coordinator?(@eg) => true)

    ManualDonation.stub!(:find).and_return( [ 
      @d1 = mock_model(ManualDonation, :id => 1, :motivation_code => 1, :original_amount => 30, :conversion_rate => 1.06),
      @d2 = mock_model(ManualDonation, :id => 2, :motivation_code => 2, :original_amount => 40, :conversion_rate => 1.06)
    ] )
    Profile.stub!(:find_all_by_motivation_code).and_return( [ 
      stub('p1', :motivation_code => 1, :id => 1),
      stub('p2', :motivation_code => 2, :id => 2),
    ] )
  end

  it "should preview the right manual donations on preview_block_set_manual_donation_rate" do
    setup_viewer; setup_eg;
    setup2
    
    get :preview_block_set_manual_donation_rate,
           :start => { :year => 2009, :month => 1, :day => 1 },
           :end => { :year => 2009, :month => 1, :day => 30 },
           :rate => 1.06

    assigns('profiles').should_not be_nil
    assigns('profiles')[1].should_not be_nil
    assigns('profiles')[1].id.should == 1
    assigns('profiles')[2].should_not be_nil
    assigns('profiles')[2].id.should == 2
    assigns('manual_donations').length.should == 2
  end

  it "should convert the right manual donations on convert_block_set_manual_donation_rate" do
    setup_viewer; setup_eg;
    setup2

    @d1.should_receive(:conversion_rate=).with(1.06)
    @d1.should_receive(:amount=).with(31.80)
    @d1.should_receive(:status=).with('received')
    @d2.should_receive(:conversion_rate=).with(1.06)
    @d2.should_receive(:amount=).with(BigDecimal.new('42.40')) # why does this get a BigDecimal, when d1 gets float?
    @d2.should_receive(:status=).with('received')

    @d1.should_receive(:save!)
    @d2.should_receive(:save!)

    post :convert_block_set_manual_donation_rate,
           :start => { :year => 2009, :month => 1, :day => 1 },
           :end => { :year => 2009, :month => 1, :day => 30 },
           :rate => 1.06,
           :set_status => 'received'
  end
end

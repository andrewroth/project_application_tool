require File.dirname(__FILE__) + '/../spec_helper'

describe "/profiles/crisis_info" do

  before(:each) do
    @user = mock_model(User)
  end

  it "should not crash" do
    Gender.stub!(:find).and_return([ ])
    render "/profiles/crisis_info"
    response.should have_tag('select#emerg_emerg_passportExpiry_1i') do
      with_tag 'option', 5.years.from_now.year.to_s
      with_tag 'option', 10.years.from_now.year.to_s
    end
  end
end

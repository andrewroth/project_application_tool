require File.dirname(__FILE__) + '/../spec_helper'

describe CustomElementRequiredSectionsController do
  def setup_section(section)
    @reqd_sections = mock('reqd_sections', :find_by_name_and_attribute => section)
    @e = mock('element', :custom_element_required_sections => @reqd_sections)
    Element.stub!(:find).and_return(@e)
  end

  it "should create a section on positive set" do
    setup_viewer; setup_eg;

    setup_section(nil)
    @reqd_sections.should_receive(:create).with(:name => 'a', :attribute => 'b')

    get :set, :element_id => 1, :checked => 'true', :name => 'a', :attribute => 'b'
  end

  it "should destroy a section on negative set" do
    setup_viewer; setup_eg;

    @section = mock('section')
    @section.should_receive(:destroy)
    setup_section(@section)

    get :set, :element_id => 1, :checked => 'false', :name => 'a', :attribute => 'b'
  end
end

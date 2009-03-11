require File.dirname(__FILE__) + '/../test_helper'

class EventGroupTest < Test::Unit::TestCase
  fixtures :event_groups, "authservice/ministries"
  

  def test_should_convert_event_group_to_string_of_proper_format
    assert_equal event_groups(:c4c).to_s, "Power to Change, Canada - Campus for Christ", "Event Group with ministry not converted properly"
    assert_equal event_groups(:no_ministry).to_s, "Event Group with no Ministry", "Event Group with no ministry not converted properly"
    assert_equal event_groups(:missing_ministry).to_s, "Event Group with missing Ministry", 
      "Event Group with missing ministry not converted properly"
  end

end

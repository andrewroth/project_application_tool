require File.dirname(__FILE__) + '/../test_helper'

class EventGroupTest < Test::Unit::TestCase
  fixtures :event_groups, "authservice/ministries"
  

  def test_should_convert_event_group_to_string_of_proper_format
    assert_equal event_groups(:c4c).to_s, "Power to Change, Canada - Campus for Christ", "Event Group not converted properly"
  end

end

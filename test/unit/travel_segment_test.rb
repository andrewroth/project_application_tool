require File.dirname(__FILE__) + '/../test_helper'

class TravelSegmentTest < Test::Unit::TestCase
  #fixtures :travel_segments

  # Replace this with your real tests.
  def test_parse_1
    ts = TravelSegment.parse("AA 967K 15JAN LAXMIA HK1 825A 410P+1")
    assert_parse_1 ts

    ts = TravelSegment.parse("    AA 967K 15JAN LAXMIA HK1 825A 410P+1  ")
    assert_parse_1 ts

    ts = TravelSegment.parse("AA 967K 15JAN LAXMIA HK1 825A 410P+")
    assert_parse_1 ts

    ts = TravelSegment.parse("AA 967K 15JAN LAXMIA HK1 825A 410P+2")
    assert_parse_1 ts
  end

  def test_parse_arrival_boundary
    ts = TravelSegment.parse("AA 967K 31JAN LAXMIA HK1 825A 410P+2")
    # todo
  end

  def test_parse_time
    ts = TravelSegment.parse("AA 967K 31JAN LAXMIA HK1 825A 410P+2")
    assert_equal 8, ts.departure_time.hour
    ts = TravelSegment.parse("AA 967K 31JAN LAXMIA HK1 1125A 410P+2")
    assert_equal 11, ts.departure_time.hour
    ts = TravelSegment.parse("AA 967K 31JAN LAXMIA HK1 1125A 410P+2")
    assert_equal 11, ts.departure_time.hour
  end

  protected

  def assert_parse_1(ts)
    assert_equal 31, ts.departure_time.day
    assert_equal 1, ts.departure_time.month
    assert_equal 1, ts.arrival_time.day
    assert_equal 2, ts.arrival_time.month
  end

  def assert_parse_1(ts)
    # AA 967K 15JAN LAXMIA HK1 825A 410P+1
    assert_equal 'AA', ts.carrier
    assert_equal '967', ts.flight_no
    assert_equal 15, ts.departure_time.day
    assert_equal 1, ts.departure_time.month
    assert_equal 'LAX', ts.departure_city

    assert_equal 'MIA', ts.arrival_city
    assert_equal 8, ts.departure_time.hour
    assert_equal 25, ts.departure_time.min

    assert_equal 16, ts.arrival_time.hour
    assert_equal 16, ts.arrival_time.day
  end
end

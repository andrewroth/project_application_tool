require 'date'

class Time
  def to_local_datetime() to_datetime(DateTime.now.offset) end
  def to_gm_datetime() to_datetime(Rational(0,1)) end

  def to_datetime(offset = nil)
    # Convert seconds + microseconds into a fractional number of seconds
    seconds = sec + Rational(usec, 10**6)

    # Convert a UTC offset measured in minutes to one measured in a
    # fraction of a day.
    offset ||= Rational(utc_offset, 60 * 60 * 24)
    DateTime.new(year, month, day, hour, min, seconds, offset)
  end
end

class DateTime
  def to_gm_time() to_time(new_offset, :gm) end
  def to_local_time() to_time(new_offset(DateTime.now.offset-offset), :local) end

  private 

  def to_time(dest, method) 
    # Convert a fraction of a day to a number of microseconds
    usec = (dest.sec_fraction * 60 * 60 * 24 * (10**6)).to_i
    Time.send(method, dest.year, dest.month, dest.day, dest.hour, dest.min, dest.sec, usec)
  end
end     


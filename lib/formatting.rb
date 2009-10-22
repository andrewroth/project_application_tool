module Formatting
  def value_to_time(v)
    begin
      [ Time, DateTime, ActiveSupport::TimeWithZone ].include?(v.class) ? v : Time.parse(v)
    rescue
      ""
    end
  end

  def format_date(value=nil)
    time = value_to_time(value)
    return time if time == ''
    return time.strftime('%Y/%m/%d')
  end
  
  def format_datetime(value=nil, style=:default)
    return '' if value.to_s.empty?
    return format_date(value) if value.class == Date

    time = value_to_time(value)
    return time if time == ''

    if style == :ts
      time.strftime("%b %d %y %H:%M %Z")
    else
      time.strftime("%Y/%m/%d %H:%M %Z")
    end
  end
end

module Formatting
  def format_date(value=nil)
    return '' if value.to_s.empty?
    time = ''
    begin
      time = value.class == Time ? value : Time.parse(value)
      return time.strftime('%Y/%m/%d')
    rescue
    end
    time.to_s
  end
  
  def format_datetime(value=nil, style=:default)
    return '' if value.to_s.empty?
    return format_date(value) if value.class == Date

    time = (value.class == Time || value.class == DateTime) ? value : Time.parse(value)

    if style == :ts
      time.strftime("%b %d %y %H:%M")
    else
      time.strftime("%Y/%m/%d %H:%M")
    end
  end
end

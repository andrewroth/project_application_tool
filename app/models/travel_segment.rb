# force my impl of ordered hash, else active_support's will be used
require 'class_level_formatting'
require 'formatting'

class TravelSegment < ActiveRecord::Base
  load 'my_ordered_hash.rb'
  include ClassLevelFormatting
  include Formatting
  
  has_many :profile_travel_segments
  has_many :profiles, :through => :profile_travel_segments
  
  has_many :taggings, :as => :tagee
  has_many :tags_o, :through => :taggings, :class_name => 'Tag', :source => :tag
  
  after_save :save_tag_objects_from_tags
  attr_writer :tags
  
  cattr_reader :all_editors
  cattr_reader :restricted
  cattr_reader :add_new_ts_editors
  
  @@all_editors = MyOrderedHash.new( [
     :flight_no, :textfield_editor,
     :departure_city, :textfield_editor,
     :departure_time, :datetime_editor,
     :arrival_city, :textfield_editor,
     :arrival_time, :datetime_editor,
     :carrier, :textfield_editor,
     :notes, :textfield_editor,
     :tags, :text_field_with_auto_complete_editor,
   ])
  
  @@restricted = @@all_editors.clone
  @@restricted.delete(:tags)
  
  @@add_new_ts_editors = MyOrderedHash.new( [
     :departure_city, :textfield_editor,
     :arrival_city, :textfield_editor,
     :carrier, :textfield_editor,
     :flight_no, :textfield_editor,
     :departure_time, :datetime_editor,
     :arrival_time, :datetime_editor,
     :notes, :textfield_editor,
     :tags, :text_field_with_auto_complete_editor,
   ])
  
  def <=>(other)
    departure_time <=> other.departure_time
  end
  
  def short_desc
    "#{flight_no} #{format_datetime(departure_time, :ts)} " + 
      "#{departure_city} to #{format_datetime(arrival_time, :ts)} #{arrival_city} " #+ 
   #   ("(notes: #{notes})" if (notes && !notes.empty?)).to_s
   # no notes per Russ's request
  end
  
  def long_desc
    "#{flight_no} #{format_datetime(departure_time, :ts)} " + 
      "#{departure_city} to #{format_datetime(arrival_time, :ts)} #{arrival_city} " + 
      ("(notes: #{notes})" if (notes && !notes.empty?)).to_s
  end
  
  def save_tag_objects_from_tags
    @tags ||= tags
    tags = @tags.split(',').collect{ |t| t.strip }
    
    to_remove_at_end = self.tags_o.collect &:id
    
    # make sure each tag exists in db, and that this ts is tagged by each
    tags.each do |t|
      # make sure tag exists
      tag_obj = Tag.find_by_name t
      if tag_obj.nil?
        tag_obj = Tag.create :name => t
      end
      
      # and tag it
      tagging_obj = taggings.find_by_tag_id tag_obj.id
      if tagging_obj.nil?
        tagging_obj = taggings.create :tag_id => tag_obj.id, :tagee_type => self.class.to_s
      end
      
      # don't need to delete this tag at the end since it was in the tags line
      to_remove_at_end.delete tag_obj.id
    end
    
    # remove all tags that aren't in the tags line
    to_remove_at_end.each do |tag_obj|
      tagging_obj = taggings.find_by_tag_id tag_obj.id
      tagging_obj.destroy if tagging_obj
    end

    true
  end
  
  def tags
    @tags || tags_o.collect{ |t| t.name }.join(', ')
  end
  
  def TravelSegment.new(ts = {})
    ts[:year] ||= $year
    ts[:departure_time] ||= Time.now
    ts[:arrival_time] ||= Time.now
    TravelSegment.all_editors.each_pair do |k,v|
      ts[k] = 'click to edit' if v == :inplace_editor
    end

    super ts
  end
  
  def TravelSegment.filter(travel_segments, params)
    arrival_city          = params[:arrival_city].to_s
    arrival_date          = params[:arrival_time].to_s
    carrier               = params[:carrier].to_s
    departure_city        = params[:departure_city].to_s
    departure_date        = params[:departure_date].to_s
    flight_num            = params[:flight_num].to_s
    notes                 = params[:notes].to_s
    tags                  = params[:travel_segment].nil? ? '' : 
                 params[:travel_segment][:tags].downcase.split(',').collect{ |tag| tag.strip }
    
    arrival_city.gsub!(/[\.\|\(\)\[\\\^\{\+\$\*\?\}\]]/, "")
    arrival_city.strip!
    carrier.gsub!(/[\.\|\(\)\[\\\^\{\+\$\*\?\}\]]/, "")
    carrier.strip!
    departure_city.gsub!(/[\.\|\(\)\[\\\^\{\+\$\*\?\}\]]/, "")
    departure_city.strip!
    flight_num.gsub!(/[\.\|\(\)\[\\\^\{\+\$\*\?\}\]]/, "")
    flight_num.strip!
    notes.gsub!(/[\.\|\(\)\[\\\^\{\+\$\*\?\}\]]/, "")
    notes.strip!
    arrival_date.gsub!(/[\.\|\(\)\[\\\^\{\+\$\*\?\}\]]/, "")
    departure_date.gsub!(/[\.\|\(\)\[\\\^\{\+\$\*\?\}\]]/, "")
    arrival_date_array    = arrival_date.split()    
    departure_date_array  = departure_date.split()

    travel_segments.collect! { |ts| 
      tl = ts.tags.downcase
      
      if !(arrival_city == "") && !(ts.arrival_city =~ /.*#{arrival_city}.*/i)
        nil
      elsif !(arrival_date == "") && !(format_datetime(ts.arrival_time,:ts) =~ /.*#{arrival_date_array[0]}.*#{arrival_date_array[1]}.*#{arrival_date_array[2]}.*#{arrival_date_array[3]}.*/i)
        nil
      elsif !(carrier == "") && !(ts.carrier =~ /.*#{carrier}.*/i)
        nil
      elsif !(departure_city == "") && !(ts.departure_city =~ /.*#{departure_city}.*/i)
        nil
      elsif !(departure_date == "") && !(format_datetime(ts.departure_time,:ts) =~ /.*#{departure_date_array[0]}.*#{departure_date_array[1]}.*#{departure_date_array[2]}.*#{departure_date_array[3]}.*/i)
        nil
      elsif !(flight_num == "") && !(ts.flight_no =~ /.*#{flight_num}.*/i)
        nil
      elsif !(notes == "") && !(ts.notes =~ /.*#{notes}.*/i)
        nil
      elsif !tags.empty? && !tags.find{|tag| tl =~ /#{tag}/ }
        nil
      else
        ts
      end
    }
    travel_segments.compact!
    
    travel_segments
  end 
  
  protected

=begin
returns a new travel segment, parsed from s, based on the specs
we got from the travel agent

AA 967K 15JAN LAXMIA HK1 825A 410P+1 

AA = Airline code (always two characters)

967K = flight number and booking class, we do not need to store the booking class, the flight number is between 1 and 4 digits

15JAN = day in DDMonth format, note the year is not given.  we need to figure out the year... assume dates are always in the future, however, the travel agent cannot generate info for more than 330 days in advance, so if you suspect the day is more than 330 days ahead, assume it's in the past

LAXMIA = city pair of departure and arrival airport for example, LAX to MIA (we need to find a list of all airport codes and then input both the airport name/city and the code i.e. Toronto (YYZ).  (you can also email shane@kindertravel.com if you're stuck)

HK1 = booking status - can be dropped

825A = departure time on the date indicated

410P = arrival time (appended with the following '+', '+1' or '+2' if next day arrival or '-' if previous day)

=end
  def self.parse(s, options = {})
    s =~ /(\w\w) *(\d+)\w+ +(\d+)(\w+) +(\w\w\w)(\w\w\w) +\w+ +(\d?\d)(\d\d)(\w)? +(\d?\d)(\d\d)(\w)?(\+|-)?(\d)?/

    airline = $1
    flight_no = $2

    day = $3
    month = $4
    hour = $7
    minute = $8
    ampm = if $9 then "#{$9}M" else "" end
    departure_time = Time.parse("#{day} #{month} #{Time.now.year} #{hour}:#{minute} #{ampm}")
    # todo: correct year based on 330 days ahead limit
    if departure_time > 330.days.from_now then
      departure_time += 1.year
    end
    departure_city = $5

    hour = $10
    minute = $11
    ampm = if $12 then "#{$12}M" else "" end
    arrival_time = Time.parse("#{day} #{month} #{Time.now.year} #{hour}:#{minute} #{ampm}")
    # correct year based on 330 days ahead limit
    if arrival_time > 330.days.from_now then
      arrival_time += 1.year
    end
    departure_city = $5

    plus_or_minus = $13.to_s
    relative_arrival_time = if plus_or_minus == '+'
        arrival_time + 1.day
      elsif plus_or_minus == '-'
        arrival_time - 1.day
      else
        arrival_time
      end
    arrival_time = Time.parse("#{relative_arrival_time.day} #{relative_arrival_time.strftime("%b")} #{relative_arrival_time.year} #{hour}:#{minute} #{ampm}")
    
    dep_city = city_from_code $5, options
    arr_city = city_from_code $6, options

    TravelSegment.new(:year => departure_time.year, :departure_city => dep_city, :departure_time => departure_time,
       :arrival_city => arr_city, :arrival_time => arrival_time, :flight_no => flight_no, :carrier => airline)
  end

  def self.city_from_code(code, options = {})
    airport = Airport.find_by_code_with_lookup(code)
    return code unless airport

    country = PatCountry.find_by_code(airport.country_code)
    country_name = if country then country.name else airport.country_code end
    extra_info = if ['US','CA'].include?(airport.country_code) then airport.area_code else
                          country_name end

    if options[:demo]
      color("#{airport.city} (#{code})", 'purple') + '|' +
      color("#{airport.city}#{', '+country_name unless ['US','CA'].include?(airport.country_code)} (#{code})", 'red') + '|' +
      color("#{airport.city}, #{extra_info} (#{code})", 'green') + '|' +
      color("#{airport.city}, #{extra_info} (#{airport.name} / #{code})", 'blue') + '|' +
      color("#{airport.city}#{', ' + country_name unless ['US','CA'].include?(airport.country_code)} (#{airport.name} / #{code})", 'brown')
    else
      "#{airport.city}, #{extra_info} (#{code})"
    end
  end

  def self.color(s, c)
    "<span style='color:#{c}'>#{s}</span>"
  end

  # creates a new object through the parse line if possible, 
  #   otherwise uses the default parse_line
  def self.new_with_parse(params)
    if params[:parse_line].to_s.empty?
      params.delete :parse_line # need to get rid of it else we get errors

      TravelSegment.new params
    else
      ts = TravelSegment.parse params[:parse_line]

      # allow notes and tags to be set
      ts.notes = params[:notes] unless params[:notes].nil? || params[:notes].empty?
      ts.tags = params[:tags] unless params[:tags].nil? || params[:tags].empty?

      ts
    end
  end

  def self.current
    tss = TravelSegment.find :all, :conditions => [ 'arrival_time > :cutoff', { :cutoff => 10.days.ago } ]
    tss.sort { |a,b|
      a_dt_nil = a.departure_time.nil?
      b_dt_nil = b.departure_time.nil?
      if a_dt_nil && b_dt_nil
        0
      elsif a_dt_nil && !b_dt_nil
        1
      elsif !a_dt_nil && b_dt_nil
        -1
      else
        b.departure_time <=> a.departure_time
      end
    }
  end
end

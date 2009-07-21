class CopyCountriesData < ActiveRecord::Migration

  CANADIAN_PROVINCES = ["Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland", "Northwest Territories", "Nova Scotia", "Nunavut", "Prince Edward Island", "Quebec", "Saskatchewan", "Yukon", "Ontario"]

  US_STATES = ["Alaska", "Alabama", "Arkansas", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]

  AU_STATES = ["New South Whales", "Queensland", "South Australia", "Tasmania", "Victoria", "Western Australia", "Australia Capital Territory", "Jervis Bay Territory", "Northern Territory"]

  def self.down
  end

  def self.up

    for list, country_name in { CANADIAN_PROVINCES => 'Canada', US_STATES => 'United States', AU_STATES => 'Australia' }
      c = Country.find_by_country_desc country_name
      puts "Converting #{c.country_desc}"

      ps = Province.find_all_by_province_desc list
      for p in ps
        p.country_id = c.id
        p.save!
      end
    end

    puts "Setting country for all people.  This might take a while."
    total = Person.count
    percent_inc = 1
    percent_count = (total * (percent_inc.to_f / 100.0)).to_i
    i = percent = 0
    #puts "percent_inc: #{percent_inc} percent_count: #{percent_count}"
    for p in Person.find(:all, :include => [ :loc_province, :perm_province ])
      i += 1
      if i == percent_count
        i = 0
        percent += percent_inc
        puts "#{percent}%"
      end

      p.country_id = p.perm_province.country_id if p.perm_province
      p.person_local_country_id = p.loc_province.country_id if p.loc_province
      p.save!
    end

  end

end

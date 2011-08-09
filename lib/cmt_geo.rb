class CmtGeo
  @@country_code_to_states_cache = {}

  def self.all_countries
    Country.all.collect{|c| [c.country_desc, c.country_shortDesc]}
  end
  def self.all_states
    Country.all.collect{ |c| 
      [ c.country_shortDesc, c.states.collect{ |s| [ s.name, s.abbrev ] } ]
    }
  end
  def self.states_for_country(c)
    if c.is_a?(Country)
      country = c
    elsif c.is_a?(String)
      country = find_country_from_code(c)
    end
    return [] unless country
    if states = @@country_code_to_states_cache[c]
      return states
    else
      return states = @@country_code_to_states_cache[c] = country.states.collect{ |s| [ s.name, s.abbrev ] }
    end
  end
  def self.campuses_for_state(s, c)
    state = State.find_by_province_shortDesc(s)
    state_id = state.id if state
    return Campus.all.select{ |c| c.province_id == state_id }
  end
  def self.campuses_for_country(c)
    country = Country.find_by_country_shortDesc(c)
    return [] unless country
    country.states.collect{ |p| p.campuses }.flatten.sort{ |c1,c2| c1.name <=> c2.name }
  end
  def self.lookup_country_name(code)
    country = find_country_from_code(code)
    return nil unless country
    country.name
  end
  def self.lookup_country_code(name)
    country = find_country_from_name(name)
    return nil unless country
    country.abbrev
  end
   
  private

  def self.find_country_from_code(c)
    Country.find :first, :conditions => { Country._(:abbrev) => c } 
  end
  def self.find_country_from_name(c)
    Country.find :first, :conditions => { Country._(:name) => c } 
  end
end

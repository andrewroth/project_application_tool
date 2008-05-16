require 'net/http'
require 'rexml/document'

class Airport < ActiveRecord::Base
  include REXML

  def self.find_by_code_with_lookup(code)
    airport = find_by_code
    return airport if airport

    # otherwise add it from the internet
    airport = self.lookup code
    return nil unless airport
    airport.save!

    return airport
  end

  # grabs an airport info off the net
  #
  # two best site are 
  #
  # http://www.flightstats.com/go/Suggest/airportSuggestProcess.do?desiredResults=10&searchSubstring=<CODE>
  # http://www.jibbering.com/routeplanner/airport.1?<CODE>
  #
  # The first one has things in a city / provice/state / country format, the second one 
  # lumps city and province/state into a 'name' field.. so the first one is better imo
  # since we start with better data.
  # 
  def self.lookup(code)
    Net::HTTP.start('www.flightstats.com', 80) do |http|
      response = http.get("/go/Suggest/airportSuggestProcess.do?desiredResults=10&searchSubstring=#{code}", 'Accept' => 'text/xml')

      doc = Document.new response.body
      airport_node = XPath.first(doc, "//airport[@code='#{code}']")
      return nil unless airport_node
      atts = airport_node.attributes

      airport = Airport.new :code => code,
                            :country_code => atts['countryCode'],
                            :area_code => atts['stateCode'],
                            :name => atts['name'],
			    :city => atts['city']
      return airport;
    end
  end
end

require 'test/unit'

#Unit tests.
Dir[File.dirname(__FILE__) + '/unit/*.rb'].each do |file|
  require file
end

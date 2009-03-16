require 'test/unit'

#Integration tests.
Dir[File.dirname(__FILE__) + '/functional/*.rb'].each do |file|
  require file
end

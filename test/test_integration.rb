require 'test/unit'

#Integration tests.
Dir[File.dirname(__FILE__) + '/integration/*.rb'].each do |file|
  require file
end

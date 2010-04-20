class Address < ActiveRecord::Base
  load_mappings
  include Common::Core::Address
end

class Address < ActiveRecord::Base
  load_mappings
  include Common::Core::Address
  include Common::Core::Ca::Address
end

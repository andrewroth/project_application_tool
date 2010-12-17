class DonationType < ActiveRecord::Base
  load_mappings
  include Common::Core::Ca::DonationType
end

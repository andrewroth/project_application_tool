class Country < ActiveRecord::Base
  load_mappings
  include Common::Core::Country
  include Common::Core::Ca::Country

  has_many :provinces
end


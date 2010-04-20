class Country < ActiveRecord::Base
  load_mappings
  include Common::Core::Country

  has_many :provinces
end


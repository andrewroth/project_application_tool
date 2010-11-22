class Country < ActiveRecord::Base
  load_mappings
  include Common::Core::Country
end


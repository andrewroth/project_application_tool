class Ministry < ActiveRecord::Base
  load_mappings
  include Common::Core::Ministry
end


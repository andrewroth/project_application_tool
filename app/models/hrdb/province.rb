class Province < ActiveRecord::Base
  load_mappings
  include Common::Core::State
  include Common::Core::Ca::State
end


class State < ActiveRecord::Base
  load_mappings
  include Common::Core::State
end


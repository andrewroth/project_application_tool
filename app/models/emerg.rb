class Emerg < ActiveRecord::Base
  load_mappings
  include Common::Core::Emerg
  include Common::Core::Ca::Emerg
end

class PersonExtra < ActiveRecord::Base
  load_mappings
  include Common::Core::Ca::PersonExtra
end

class Gender < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::Gender
end

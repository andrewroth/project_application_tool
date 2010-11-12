class Region < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::Region
end

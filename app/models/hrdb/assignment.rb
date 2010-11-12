class Assignment < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::Assignment
end

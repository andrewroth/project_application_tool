class Assignmentstatus < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::Assignmentstatus
end

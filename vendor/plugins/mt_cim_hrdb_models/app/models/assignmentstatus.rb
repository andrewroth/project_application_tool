class Assignmentstatus < ActiveRecord::Base
  load_mappings

  has_many :assignments
end

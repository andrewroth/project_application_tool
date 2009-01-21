class Access < ActiveRecord::Base
  load_mappings

  belongs_to :user, :class_name => "User", :foreign_key => "viewer_id"
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
end


class EventGroupResourceProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :event_group_resource
end

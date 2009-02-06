class EventgroupCoordinator < ActiveRecord::Base
  belongs_to :event_group
  belongs_to :viewer
end

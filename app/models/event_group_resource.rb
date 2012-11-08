class EventGroupResource < ActiveRecord::Base
  belongs_to :event_group
  belongs_to :resource
end

class EventgroupCoordinator < ActiveRecord::Base
  belongs_to :event_group
  belongs_to :viewer
  def project() :all end
end

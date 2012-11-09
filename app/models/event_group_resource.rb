class EventGroupResource < ActiveRecord::Base
  belongs_to :event_group
  belongs_to :resource
  has_many :event_group_resource_projects
  has_many :projects, :through => :event_group_resource_projects
  delegate :size, :to => :resource

  def as_json(params)
    super(params.merge(:methods => [ :size, :project_ids ]))
  end
end

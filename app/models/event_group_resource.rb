class EventGroupResource < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :event_group
  belongs_to :resource
  has_many :event_group_resource_projects
  has_many :projects, :through => :event_group_resource_projects
  delegate :size, :to => :resource

  def human_size
    number_to_human_size(size)
  end

  def as_json(params)
    super(params.merge(:methods => [ :human_size, :project_ids ]))
  end
end

class EventGroupResource < ActiveRecord::Base
  belongs_to :event_group
  belongs_to :resource
  delegate :size, :to => :resource

  def as_json(params)
    super(params.merge(:methods => [ :size ]))
  end
end

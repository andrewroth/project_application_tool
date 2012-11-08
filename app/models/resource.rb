class Resource < ActiveRecord::Base
  has_many :event_group_resources
  has_many :event_groups, :through => :event_group_resources
  has_many :resource_projects
  has_many :projects, :through => :resource_projects

  has_attachment :storage => :file_system,
    :path_prefix => 'public/resources'
end

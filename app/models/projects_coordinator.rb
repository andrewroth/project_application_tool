class ProjectsCoordinator < ActiveRecord::Base
  validates_presence_of :viewer_id

  belongs_to :viewer
end

class ProjectsCoordinator < ActiveRecord::Base
  validates_presence_of :viewer_id

  belongs_to :viewer

  def event_group() :all end
  def project() :all end
end

class ProjectDirector < ActiveRecord::Base
  belongs_to :project
  belongs_to :viewer
  def event_group() project.try(:event_group) end
end

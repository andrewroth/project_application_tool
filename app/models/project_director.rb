class ProjectDirector < ActiveRecord::Base
  belongs_to :project
  belongs_to :viewer
end

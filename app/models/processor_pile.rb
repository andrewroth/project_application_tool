class ProcessorPile < ActiveRecord::Base
  belongs_to :project
  belongs_to :appln
  belongs_to :locked_by_viewer, :class_name => "Viewer", 
    :foreign_key => :locked_by_viewer_id, 
    :include => :persons
end

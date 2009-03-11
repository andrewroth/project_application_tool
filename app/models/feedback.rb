class Feedback < ActiveRecord::Base
  belongs_to :viewer
  
  def Feedback.FEEDBACK_TYPES
    [
      [ "Issue",            "issue"],
      [ "Feature Request",  "feature"],
      [ "General Comment",  "comment"]
    ]
  end
  
  validates_presence_of :description
  validates_inclusion_of :feedback_type, :in => Feedback.FEEDBACK_TYPES.map {|disp, value| value}
  
end

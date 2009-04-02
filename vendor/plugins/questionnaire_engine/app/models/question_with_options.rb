class QuestionWithOptions < Question
  has_many  :question_options, :foreign_key => :question_id, :dependent => :destroy, 
            :order => 'position'
  
  def xml_children
    # not sure why question_options doesn't work, but whatever
    QuestionOption.find_all_by_question_id(id, :order => 'position')
  end
end

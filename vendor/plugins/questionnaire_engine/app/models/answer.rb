class Answer < ActiveRecord::Base
  set_table_name "#{QE.prefix}answers"
  belongs_to :element, :foreign_key => "question_id"
  
  def empty?
    answer.nil? || answer.to_s.empty?
  end

  def <=>(a2)
    a1 = self
    a1.instance_id != a2.instance_id ? 
          (a1.instance_id <=> a2.instance_id) : # sort on instance_id first
          (a1.question_id <=> a2.question_id)   # question_id second
  end
end

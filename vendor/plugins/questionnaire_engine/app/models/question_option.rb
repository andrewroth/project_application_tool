class QuestionOption < ActiveRecord::Base
  include ModelXML
  
  set_table_name "#{QE.prefix}question_options"
  acts_as_list :scope => :question_id
  belongs_to :question
end

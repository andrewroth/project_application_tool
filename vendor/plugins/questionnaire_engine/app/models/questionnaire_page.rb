class QuestionnairePage < ActiveRecord::Base
  include ModelXML
  set_table_name "#{QE.prefix}questionnaire_pages"
  
  belongs_to :page
  belongs_to :questionnaire
  acts_as_list :scope => :questionnaire_id
  
  def xml_children
    [ page ]
  end
end

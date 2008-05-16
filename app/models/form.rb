class Form < ActiveRecord::Base
  has_many :applns
  belongs_to :questionnaire, :dependent => :destroy
  belongs_to :event_group
  after_create :create_questionnaire_for_this_form

  def to_s_with_ministry_and_eg_path
    eg_s = event_group.nil? ? '[no event group]' : event_group.to_s_with_ministry_and_eg_path

    "#{eg_s} #{name}"
  end
  
  def to_s_with_eg_path
    eg_s = event_group.nil? ? '[no event group]' : event_group.to_s_with_eg_path

    "#{eg_s} #{name}"
  end

  def title_for_questionnaire() self.name end

  def title() name end

  protected

  def create_questionnaire_for_this_form
    return if !questionnaire_id.nil?
    q = Questionnaire.create(:title => title_for_questionnaire)
    q.type = "FormQuestionnaire"
    q.save!
    self.questionnaire_id = q.id
    self.save!
  end

end

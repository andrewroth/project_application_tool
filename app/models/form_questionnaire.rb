class FormQuestionnaire < Questionnaire
  has_one :form, :foreign_key => 'questionnaire_id'

  def name
    form.name
  end

  def title
    name
  end
end

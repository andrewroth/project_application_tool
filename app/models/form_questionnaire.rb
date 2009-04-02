require_dependency 'questionnaire_with_reference'

class FormQuestionnaire < Questionnaire
  include QuestionnaireWithReference

  has_one :form, :foreign_key => 'questionnaire_id'

  def name
    form.name
  end

  def title
    name
  end
end

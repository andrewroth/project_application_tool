module CustomPages
  def validate_project_preferences(questionnaire)
    for i in 1..2
      if questionnaire["preference#{i}_id"].nil? || 
        questionnaire["preference#{i}_id"].to_s.empty?
        errors.add_to_base("Preference#{i} can't be blank.") 
      end
    end
  end
  def validate_intern_questions(questionnaire)
    appln = (questionnaire.class == ProcessorForm) ? questionnaire.appln : questionnaire
    
    if appln.as_intern.nil? || appln.as_intern == false
      errors.clear
    end
  end
  def validate_pesonal_information(questionnaire)
    if questionnaire.viewer.email.nil? || 
      questionnaire.viewer.email.empty?
      errors.add_to_base("Email can't be blank")
    end
  end
end

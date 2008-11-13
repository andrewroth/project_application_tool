class PersonalInformation < CustomElement
  def text()
    "Personal Information Form"
  end

  def save_answer(instance, params, answers)
    @person = instance.viewer.person

    PersonalInformation.save_from_params(@person, params)
  end

  def self.save_from_params(person, params)
    # person[:email] is in the campus project app as a q with programmer
    # options, it messes up the update_attributes save since it's a defined
    # method and not a column
    if params[:appln_person]
      person_params = params[:appln_person].clone
      person_params.delete 'email'
      person.update_attributes(person_params)
      person.save!
    end
  end
end


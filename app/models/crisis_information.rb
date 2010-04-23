class CrisisInformation < CustomElement
  def text()
    "Crisis Information Form"
  end

  def save_answer(instance, params, answers)
    @person = instance.viewer.person
    @emerg = @person.get_emerg

    CrisisInformation.save_from_params(@person, params)
  end

  def self.save_from_params(person, params)
    emerg = person.get_emerg

    # note that you can't have a null emerg_passportExpiry or emerg_birthdate
    if params[:emerg]
      DateParamsParser.parse(params[:emerg], "passport_expiry")
      emerg.update_attributes(params[:emerg])
      emerg.save!
    end

    if params[:appln_person]
      data_to_take = [ :first_name, :last_name ] # legal first/last name
      person_params = {}
      for key in data_to_take
        if params[:appln_person][key].present?
          person_params[key] = params[:appln_person][key]
        end
      end
      # manually pull in birth_date
      if bd = DateParamsParser.parse(params[:appln_person], "birth_date")
        person_params[:birth_date] = bd
      end
      person.update_attributes(person_params)
      person.save!
    end

  end

end


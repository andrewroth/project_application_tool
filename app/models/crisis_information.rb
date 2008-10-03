class CrisisInformation < Element

  def text()
    "Crisis Information Form"
  end

  def save_answer(instance, params, answers)
    @person = instance.viewer.person
    @emerg = @person.emerg

    CrisisInformation.save_from_params(@person, params)
  end

  def validate!(page, instance)
      #page.errors.add_to_base("All reference fields must be completed ")
      #page.add_invalid_element(self)
  end

  def self.save_from_params(person, params)
    emerg = person.emerg

    # create a new emerg if necessary
    emerg ||= Emerg.new :person_id => person.id

    # note that you can't have a null emerg_passportExpiry or emerg_birthdate
    if params[:emerg]
      emerg.update_attributes(params[:emerg])
      emerg.save!
    end
  end

end


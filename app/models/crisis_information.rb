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
    @person = instance.viewer.person

    if @person.person_legal_fname.nil? || @person.person_legal_fname.empty?
      page.errors.add_to_base("\"Legal given names\" is required")
    end

    if @person.person_legal_lname.nil? || @person.person_legal_lname.empty?
      page.errors.add_to_base("\"Legal last name\" is required")
    end

    page.add_invalid_element(self)
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

    if params[:appln_person]
      person_params = params[:appln_person].clone
      person.update_attributes(person_params)
      person.save!
    end

  end

end


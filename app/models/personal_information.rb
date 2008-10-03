class PersonalInformation < Element

  def text()
    "Personal Information Form"
  end

  def save_answer(instance, params, answers)
    @person = instance.viewer.person
    @emerg = @person.emerg

    # create a new emerg if necessary
    @emerg ||= Emerg.new :person_id => @person.id

    # person[:email] is in the campus project app as a q with programmer
    # options
    if params[:person]
      person_params = params[:person].clone
      person_params.delete 'email'
      @person.update_attributes(person_params)
      @person.save!
    end

    # note that you can't have a null emerg_passportExpiry
    if params[:emerg]
      params[:emerg][:emerg_passportExpiry] ||= '0000-00-00'
      @emerg.update_attributes(params[:emerg])
      @emerg.save!
    end
  end

  def validate!(page, instance)
      #page.errors.add_to_base("All reference fields must be completed ")
      #page.add_invalid_element(self)
  end
end


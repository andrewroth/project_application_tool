class CampusInformation < Element

  def text()
    "Campus Information Form"
  end

  def save_answer(instance, params, answers)
    person = instance.viewer.person

    CampusInformation.save_from_params(person, params)
  end

  def validate!(page, instance)
    #page.errors.add_to_base("All reference fields must be completed ")
    #page.add_invalid_element(self)
  end

  def CampusInformation.save_from_params(person, params)
    if params[:appln_person].present? && 
      params[:appln_person][:school_year_id].present? &&
      params[:appln_person][:grad_date].present? &&
      params[:appln_person][:campus_id].present?

      grad_date = DateParamsParser.parse(params[:appln_person], "grad_date")
      campus_id = params[:appln_person][:campus_id]
      school_year_id = params[:appln_person][:school_year_id]
      c = Campus.find(campus_id)

      # look for an existing one
      @campus_involvement = person.all_campus_involvements.find :first, :conditions => { :campus_id => campus_id }
      @campus_involvement ||= person.all_campus_involvements.new :start_date => Date.today, :ministry_id => c.derive_ministry.try(:id), :campus_id => c.id

      if @campus_involvement.new_record?
        @campus_involvement.school_year_id = school_year_id;
        @campus_involvement.save!
      else
        @campus_involvement.update_student_campus_involvement({}, ::MinistryRole.default_student_role.id,
                                                              :same, school_year_id, campus_id)
      end

      return true
    else
      return false
    end
  end
end


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

=begin
  def self.save_from_params(person, params)
    # person[:email] is in the campus project app as a q with programmer
    # options, it messes up the update_attributes save since it's a defined
    # method and not a column
    if params[:person]
      person_params = params[:person].clone
      person_params.delete 'email'
      person.update_attributes(person_params)
      person.save!
    end
  end
=end

  def CampusInformation.save_from_params(person, params)
    if params[:assignment] && params[:assignment][:new]
      for new_map in params[:assignment][:new].values
        a = Assignment.new new_map
        a.person_id = person.id
        a.save!
      end
    end

    if params[:assignment] && params[:assignment][:update]
      for id, upd_map in params[:assignment][:update]
        begin
          a = person.assignments.find id
        rescue Exception
        end
        a.update_attributes upd_map
        a.person_id = person.id
        a.save!
      end
    end

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


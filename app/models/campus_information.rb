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

    if params[:appln_person] && params[:appln_person][:year_in_school_id] &&
       params[:appln_person]['grad_date(1i)']

      person_year = person.person_year

      # this is bad database design on Russ's part to put 
      #  cim_hrdb_person_year.year_id instead of 
      #  cim_hrdb_person_year.year_in_school_id
      yis = params[:appln_person].delete :year_in_school_id

      py = {
        "grad_date(1i)" => params["appln_person"].delete("grad_date(1i)"),
        "grad_date(2i)" => params["appln_person"].delete("grad_date(2i)"),
        "grad_date(3i)" => params["appln_person"].delete("grad_date(3i)"),
        "year_id" => yis
      }

      person_year.update_attributes(py)

      person_year.save!
    end
  end
end


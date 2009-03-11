# Contains all the custom pages code for the projects application form.
module ApplnCustomPages

  # custom personal information save/display method
  def personal_information(save = false)
    if save && !params["person"].nil?
      @appln.viewer.person.person_email = params["person"]["email"]
      @appln.viewer.person.save!
    end
  end
  
  def get_references
    @appln.reference_instances
  end
end

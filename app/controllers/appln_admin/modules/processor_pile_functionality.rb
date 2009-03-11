module ProcessorPileFunctionality

  def set_menu
    @show_processor_menu = true
  end
  
  def ensure_evaluate_permission
    @user.set_project(@project)
    unless (@user.is_eventgroup_coordinator? || @user.is_processor?)
      flash[:notice] = "Sorry, you don't have permissions to evaluate applications."
      render :text => "", :layout => true
      return false
    end
    return true
  end
end

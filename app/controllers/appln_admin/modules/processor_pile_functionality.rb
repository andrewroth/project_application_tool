module ProcessorPileFunctionality

  def set_menu
    @show_processor_menu = true
  end
  
  def ensure_evaluate_permission
    @viewer.set_project(@project)
    unless (@viewer.is_eventgroup_coordinator? || @viewer.is_processor?)
      flash[:notice] = "Sorry, you don't have permissions to evaluate applications."
      render :text => "", :layout => true
      return false
    end
    return true
  end
end

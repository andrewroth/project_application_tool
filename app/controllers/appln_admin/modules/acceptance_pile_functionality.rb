module AcceptancePileFunctionality
  def setup
    set_user # this needs to be done before the rest of the setup, and
             # the application.rb won't be hit because this is a prepended filter

    @type = params[:type] || 'app'

    @profile = if params[:profile_id]
                 Profile.find params[:profile_id]
               elsif params[:ref_id]
                 @ref = ApplnReference.find params[:ref_id]
                 @ref.instance.profile
               elsif params[:viewer_id] && params[:project_id]
                 Profile.find_by_viewer_id_and_project_id params[:viewer_id], params[:project_id]
               end

    @pass_params = { :profile_id => (@profile.id if @profile), :type => @type }

    @appln ||= @profile.appln

    viewer = if @profile && @profile.viewer
        @profile.viewer
      elsif @appln && @appln.viewer
        @appln.viewer
      end
    name = if viewer then viewer.name else 'unknown' end

    if @appln.nil?
      render :inline => "No appln found for #{name} profile #{@profile.id} profile.inspect: #{@profile.attributes.inspect}"
      return
    end

    if @type == 'ref'
      @ref = @appln.reference_instances.find_by_reference_id params[:ref_id]
      unless @ref
        flash[:notice] = "Reference data not found.  Most likely this student hasn't completed the reference page yet."
	redirect_to :back
        return
      end

      @pass_params[:ref_id] = params[:ref_id]
      @form_title = "#{name} #{@ref.reference.text}"
    else
      @form_title = "#{name} #{@appln.form.title}"
    end

    @project = @appln.profile.project
    
    @viewer.set_project @project unless @viewer.nil?
  end

  protected
  
  def set_menu
    @show_acceptance_view_menu = true
  end
  
  def ensure_view_summary_permission
    set_can_view_summary if @can_view_summary.nil?

    @viewer.set_project(@project)
    unless (@can_view_summary)
      flash[:notice] = "You don't have permission to view this application summary."
      render :text => "", :layout => true
      return false
    end
    return true
  end
  
  def ensure_view_entire_permission
    set_can_view_entire if @can_view_entire.nil?

    @viewer.set_project(@project)
    unless (@can_view_entire)
      flash[:notice] = "You don't have permission to view this entire application."
      render :text => "", :layout => true
      return false
    end
    return true
  end
  
  def ensure_view_references_permission
    set_can_view_references if @can_view_references.nil?
    
    @viewer.set_project(@project)
    if %w(staff peer pastor).include?(params[:type]) && !@can_view_references
      flash[:notice] = "You don't have permission to view this reference."
      render :text => "", :layout => true
      return false
    end
    return true
  end
end

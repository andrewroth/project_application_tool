
module Permissions
  def halt(msg = "no permission")
    return true if @halted # to avoid the dreaded DoubleRendererError
    msg = @override_msg if @override_msg
    @halted = true
    msg += '<br />' + @debug.to_s + caller.join('<br/>') if (%w(development, test).include?(RAILS_ENV))
    render :inline => msg
    true
  end

  def is_staff
    if @viewer.is_student?(@eg)
      @viewer.is_any_project_staff(@eg) # kinda annoying, but staff get put into the
                      # students group now for some rason
    else
      true
    end
  end

  def is_project_staff
    @viewer.is_atleast_project_staff(@project)
  end

  def is_any_project_staff
    @viewer.is_any_project_staff
  end

  def is_projects_coordinator
    @viewer.is_projects_coordinator?
  end

  def is_eventgroup_coordinator
    @viewer.is_eventgroup_coordinator?(@eg)
  end

  def set_can_view_summary
    if @viewer && @viewer.is_eventgroup_coordinator?(@eg)
      @can_view_summary = true
      return
    end

    if !@viewer || !@project
      @can_view_summary = false
      return
    end

    @viewer.set_project @project
    @can_view_summary = @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_processor? ||
      @viewer.is_project_staff? || @viewer.is_project_director? ||
      @viewer.is_project_administrator?
  end

  def set_can_view_references
    if !@viewer || !@project
      @can_view_references = false
      return
    end

    @viewer.set_project @project
    @can_view_references = @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_processor?
  end

  def set_can_view_entire
    if @viewer && @viewer.is_eventgroup_coordinator?(@eg)
      @can_view_entire = true
      return
    end

    if !@viewer || !@project
      @can_view_entire = false
      return
    end

    @viewer.set_project(@project)
    @can_view_entire = @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_processor? ||
      @viewer.is_project_administrator? || @viewer.is_project_director?
  end

  def set_can_view_confidential
    if @viewer && @viewer.is_eventgroup_coordinator?(@eg)
      @can_view_confidential = true
      return
    end

    if !@viewer || !@project
      @can_view_confidential = false
      return
    end

    @viewer.set_project(@project)
    @can_view_confidential = @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_processor?
  end

  def set_can_perform_actions
    @can_perform_actions = @profile && ((@project && @viewer.is_processor?) || @viewer.is_eventgroup_coordinator?(@eg)) &&
           @profile.class == Applying
  end

  def ensure_user_owns_appln
    if !user_owns_appln(@appln)
      halt("Hey, this isn't your application") and return false
    end
  end

  def user_owns_appln(appln)
    return appln.viewer == @viewer
  end

  def is_appln_ownership_or_permission(appln)
    return true if user_owns_appln appln
    return false if @viewer.is_student?(@eg)

    # first let's check the easy case, projects coordinators can do everything
    if @viewer.is_eventgroup_coordinator?(@eg)
      return true
    else
      # this viewer doesn't own this app, see if this viewer is at least ... (determined by yield)
      for profile in appln.profiles
        r = yield appln, profile.project, profile # profile is the pile entry now
        return true if r
      end
    end
    
    return false
  end
  
  def is_project_staff
    return true if @viewer.is_eventgroup_coordinator?(@eg)
    return @viewer.is_atleast_project_staff(@project || @profile.project)
  end
  
  def is_profile_ownership_or_any_project_staff
    return true if @viewer.is_eventgroup_coordinator?(@eg)
    return true if @viewer.id == @profile.viewer_id
    @project = @profile.project
    @viewer.set_project(@project)
    @project && @viewer.is_atleast_project_staff(@project)
  end

  # longest method name ever
  def is_profile_ownership_or_processor_or_support_coach_or_director_or_administrator
    return is_profile_ownership_or_processor_or_support_coach || 
       is_profile_ownership_or_director_or_administrator
  end
  
  def is_profile_ownership_or_director_or_administrator
    is_profile_ownership_or_permission do |profile, project|
      is_project_director_or_administrator project
    end
  end
  
  def is_project_director_or_administrator(project = @project)
    return true if @viewer.is_eventgroup_coordinator?(@eg)
    @viewer.set_project(project)
    return false unless project && @viewer.is_project_director? || @viewer.is_project_administrator?
    true
  end
  
  def is_eventgroup_coordinator_or_projects_administrator(project = @project)
    return true if @viewer.is_eventgroup_coordinator?(@eg)
    project ||= @profile.project
    @viewer.set_project(project)
    return false unless project
    return @viewer.is_project_administrator?
  end

  def is_profile_ownership_or_processor_or_support_coach
    @viewer.set_project @profile.project

    is_profile_ownership_or_permission do |profile, project|
      @profile.support_coach_id == @viewer.id || is_profile_ownership_or_processor
    end
  end

  def is_profile_ownership_or_processor
    @viewer.set_project @profile.project

    is_profile_ownership_or_permission do |profile, project|
      return unless project && @viewer.is_processor?
    end
  end

  def is_project_processor(project)
    return true if @viewer.is_eventgroup_coordinator?(@eg || project.event_group)
    return false unless project

    @viewer.set_project(project)
    @viewer.is_processor?
  end

  def is_profile_processor(profile = @profile)
    is_project_processor(profile.project)
  end

  def is_appln_ownership_or_processor
    @viewer.set_project @appln.profile.project

    is_appln_ownership_or_permission(@appln) do |a, pr, pi|
      is_project_processor pr
    end
  end

  def is_profile_ownership
    has_profile_ownership
  end

  def has_profile_ownership
    return true if @viewer.is_projects_coordinator?
    halt("error: no profile given for this action") and return false unless @profile
    @profile.viewer == @viewer || (@viewer && @viewer.is_eventgroup_coordinator?(@eg))
  end

  def set_view_permissions
    return false unless @viewer

    # expects event_group set - TODO - permissions really need to be 
    # cleaned up to not use instance variables, or be more explicit on which
    # ones
    @eg = @project.event_group if @eg.nil? && @project
    set_can_view_summary
    set_can_view_references
    set_can_view_entire
    set_can_view_confidential
    set_can_perform_actions
  end

  def is_profile_ownership_or_eventgroup_coordinator
    # projects coordinator check already built into is_profile_ownership_or_permission
    is_profile_ownership_or_permission do |profile, project|
      has_profile_ownership
    end
  end

  def is_profile_ownership_or_permission
    unless @profile
      @override_msg = "Error: expecting profile id, but none provided"
      return false
    end

    if @viewer.is_eventgroup_coordinator?(@eg) then return true end
    if has_profile_ownership then return true end
    
    # April 4 2007 - we are allowing staff to modify other staff's profiles now
    # staff can't start modifying other staff's profiles
    # if @profile.class == StaffProfile then return false end

    r = yield @profile, @profile.project
  end

  def is_any_project_administrator
    @viewer.project_director_projects.find_by_id(@eg.projects.collect(&:id))
  end

  def is_any_project_director
    @viewer.project_director_projects.find_by_id(@eg.projects.collect(&:id))
  end

  def ensure_permission(m, args)
    value = self.send(m, *args)
    @debug = @debug.to_s + "permission method checked: #{m}  value: #{value}<br />"
    halt unless value
    return value
  end

  def method_missing(m, *args)
    puts "in permission method_missing: #{m.inspect}"
    m_s = m.to_s
    #puts m_s
    #puts m_s.index('ensure').to_s
    if m_s.index('ensure') == 0
      ensure_method = m_s.sub('ensure','is')
      if self.respond_to? ensure_method
        ensure_permission(ensure_method, args)
      else
        super
      end
    end
  end
end


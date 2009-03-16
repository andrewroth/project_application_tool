
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
    if @user.is_student?
      @user.is_any_project_staff(@eg) # kinda annoying, but staff get put into the
                      # students group now for some rason
    else
      true
    end
  end

  def is_project_staff
    @user.is_atleast_project_staff(@project)
  end

  def is_any_project_staff
    @user.is_any_project_staff
  end

  def is_projects_coordinator
    @user.is_projects_coordinator?
  end

  def is_eventgroup_coordinator
    @user.is_eventgroup_coordinator?
  end


  def set_can_view_summary
    if @user && @user.is_eventgroup_coordinator?
      @can_view_summary = true
      return
    end

    if !@user || !@project
      @can_view_summary = false
      return
    end

    @user.set_project @project
    @can_view_summary = @user.is_eventgroup_coordinator? || @user.is_processor? ||
      @user.is_project_staff? || @user.is_project_director? ||
      @user.is_project_administrator?
  end

  def set_can_view_references
    if !@user || !@project
      @can_view_references = false
      return
    end

    @user.set_project @project
    @can_view_references = @user.is_eventgroup_coordinator? || @user.is_processor?
  end

  def set_can_view_entire
    if @user && @user.is_eventgroup_coordinator?
      @can_view_entire = true
      return
    end

    if !@user || !@project
      @can_view_entire = false
      return
    end

    @user.set_project(@project)
    @can_view_entire = @user.is_eventgroup_coordinator? || @user.is_processor? ||
      @user.is_project_administrator? || @user.is_project_director?
  end

  def set_can_perform_actions
    @can_perform_actions = @profile && ((@project && @user.is_processor?) || @user.is_eventgroup_coordinator?) &&
           @profile.class == Applying
  end

  def ensure_user_owns_appln
    if !user_owns_appln(@appln)
      halt("Hey, this isn't your application") and return false
    end
  end

  def user_owns_appln(appln)
    return appln.viewer == @user.viewer
  end

  def is_appln_ownership_or_permission(appln)
    return true if user_owns_appln appln
    return false if @user.is_student?

    # first let's check the easy case, projects coordinators can do everything
    if @user.is_eventgroup_coordinator?
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
    return true if @user.is_eventgroup_coordinator?
    return @user.is_atleast_project_staff(@profile.project)
  end
  
  def is_profile_ownership_or_any_project_staff
    return true if @user.is_eventgroup_coordinator?
    return true if @user.id == @profile.viewer_id
    @project = @profile.project
    @user.set_project(@project)
    @project && @user.is_atleast_project_staff(@project)
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
    return true if @user.is_eventgroup_coordinator?
    @user.set_project(project)
    return false unless project && @user.is_project_director? || @user.is_project_administrator?
    true
  end
  
  def is_eventgroup_coordinator_or_projects_administrator(project = @project)
    return true if @user.is_eventgroup_coordinator?
    project ||= @profile.project
    @user.set_project(project)
    return false unless project
    return @user.is_project_administrator?
  end

  def is_profile_ownership_or_processor_or_support_coach
    @user.set_project @profile.project

    is_profile_ownership_or_permission do |profile, project|
      @profile.support_coach_id == @user.id || is_profile_ownership_or_processor
    end
  end

  def is_profile_ownership_or_processor
    @user.set_project @profile.project

    is_profile_ownership_or_permission do |profile, project|
      return unless project && @user.is_processor?
    end
  end

  def is_project_processor(project)
    return true if @user.is_eventgroup_coordinator?
    return false unless project

    @user.set_project(project)
    @user.is_processor?
  end

  def is_profile_processor(profile = @profile)
    is_project_processor(profile.project)
  end

  def is_appln_ownership_or_processor
    @user.set_project @appln.profile.project

    is_appln_ownership_or_permission(@appln) do |a, pr, pi|
      is_project_processor pr
    end
  end

  def is_profile_ownership
    has_profile_ownership
  end

  def has_profile_ownership
    @profile.viewer == @user.viewer || (@user && @user.is_eventgroup_coordinator?)
  end

  def set_view_permissions
    set_can_view_summary
    set_can_view_references
    set_can_view_entire
    set_can_see_confidential_questions
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

    if @user.is_eventgroup_coordinator? then return true end
    if has_profile_ownership then return true end
    
    # April 4 2007 - we are allowing staff to modify other staff's profiles now
    # staff can't start modifying other staff's profiles
    # if @profile.class == StaffProfile then return false end

    r = yield @profile, @profile.project
  end

  def ensure_permission(m, args)
    value = self.send(m, *args)
    @debug = @debug.to_s + "permission method checked: #{m}  value: #{value}<br />"
    halt unless value
  end

  def method_missing(m, *args)
    #puts "in method_missing: #{m.inspect}"
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


class User
  require 'logger'
  attr_reader :id
  
  def eg=(eg)
    @eg = eg
  end

  def self.columns
    []
  end

  def initialize(id)
    @id = id
  end
  
  def viewer
    if @viewer.nil?
#      @viewer = Viewer.find(@id, :include => 
#        [ :applns, :accessgroups, :persons ] + 
#          Viewer.project_role_syms
#      )
      @viewer = Viewer.find @id, :include => [ { :persons => :staff }, :projects_coordinator ]
    end
    @viewer
  end
  
  def fullview?
    full_view = is_projects_coordinator? || 
      (@project && set_project(@project) && 
         (is_project_director? ||
         is_project_administrator?))
    
    if !full_view && @project
      set_project(@project)
      # processors can see full view as well
      full_view = is_processor?
    end

    full_view
  end
  
  # helper methods for access groups
  def is_student?
    if @project
      set_project(@project)
      return false if is_processor?
    end
    viewer.is_student?(@eg)
  end  

  def is_projects_coordinator?() viewer.is_projects_coordinator? end
  def is_eventgroup_coordinator?() viewer.is_eventgroup_coordinator?(@eg) end
  def is_assigned_regional_or_national?() 
    return false if viewer.person.nil?
    !viewer.person.assignments.find_all_by_campus_id(Campus.regional_national_id).empty?
  end
  
  def assert_project_set 
    if (@project.nil?)
      throw "Sorry, can't determine project-specific roles until you call set_project!"
    end
  end
  
  def is_project_director?() assert_project_set; @is_project_director end
  def is_project_administrator?() assert_project_set; @is_project_administrator end
  def is_support_coach?() assert_project_set; @is_support_coach end
  def is_project_staff?() assert_project_set; @is_project_staff end
  def is_processor?() assert_project_set; @is_processor end
  
  # returns true iff user can modify the given profile
  def can_modify_profile_in_project(p)
    set_project(p)
    (is_projects_coordinator? || is_processor? || 
      is_project_director? || is_project_administrator?)
  end
  
  def set_project(project)
    if (@project == project || project.nil?)  
      return true
    end
    @project = project
    @is_project_director = !viewer.project_director_projects.find_all{ |p| p.id == project.id }.empty?
    @is_project_administrator = !viewer.project_administrator_projects.find_all{ |p| p.id == project.id }.empty?
    @is_support_coach = !viewer.support_coach_projects.find_all{ |p| p.id == project.id }.empty?
    @is_project_staff = !viewer.project_staff_projects.find_all{ |p| p.id == project.id }.empty?
    @is_processor = !viewer.processor_projects.find_all{ |p| p.id == project.id }.empty?
    true
  end
  
  # returns a string status of the user's role related to project, useful for cache naming
  def roles_wrt_project(project)
    return 'projects_coordinator' if is_projects_coordinator?

    set_project(project)

    roles = []
    for role in [ 'project_director', 'project_administrator', 'support_coach', 'project_staff', 'processor' ]
      if eval("@is_#{role}")
        roles << role
      end
    end
    roles << 'unknown' if roles.empty?
    roles.join(',')
  end

  def is_atleast_project_staff(project)
    !viewer.current_projects_with_any_role(project.event_group).find { 
      |project_user_is_staff_on| project_user_is_staff_on == project 
    }.nil?
  end
  
  def is_any_project_staff(eg)
    !viewer.current_projects_with_any_role(eg).empty?
  end
  
  def can_evaluate?
  	is_projects_coordinator? || is_processor?		
  end
end

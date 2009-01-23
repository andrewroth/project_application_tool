require 'permissions'

# Manage projects gets its own controller cause
# there's a lot of functionality.
# 
class ManageProjectsController < ApplicationController
  include Permissions

  cache_sweeper :roles_sweeper, :only => [ :add, :remove ]

  before_filter :set_project, :except => [ :index, :list, :create, :new ]
  before_filter :determine_project_roles, :except => [ :index, :list, :new, :create ]
  before_filter :ensure_is_projects_coordinator, :only => [ :new, :create, :destroy ]
  before_filter :ensure_projects_coordinator_or_projects_administrator, :only => [ :staff, :search, :add, :remove ]
  before_filter :ensure_can_edit, :only => [ :edit, :update ]
  before_filter :set_page_title
  before_filter :set_prefix, :only => [ :search, :add, :remove ]

  layout :layout

  def layout
    request.xml_http_request? ? false : 'application'
  end

  NO_PERMISSIONS_MSG = "Sorry, you don't have permissions to do that."
  
  def ensure_can_edit
    unless (@user.is_projects_coordinator? || @user.is_project_administrator? ||
      @user.is_project_director?)

      flash[:message] = NO_PERMISSIONS_MSG
      redirect_to :controller => "main"
      return false
    end
    return true
  end
              
  def ensure_is_projects_coordinator
    unless @user.is_projects_coordinator?
      flash[:message] = NO_PERMISSIONS_MSG
      redirect_to :controller => "main"
      return false
    end
    return true
  end
  
  def set_project
    if (params[:id])
      project_id = params[:id]
    elsif (params[:project_id])
      project_id = params[:project_id]
    end
    @project = @eg.projects.find(project_id)
  end
  
  def determine_project_roles
    @user.set_project(@project)
    true
  end
  
  def set_page_title
    @page_title = "Manage Projects"
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @submenu_title = "list"
    @projects = if (@user.is_projects_coordinator?)
        @eg.projects
      else
        @user.viewer.current_projects_with_any_role(@eg).reject{ |p|
          !@eg.projects.include?(p)
        }
      end
  end

  def show
  end

  def new
    if (@user.is_projects_coordinator?)
      @project = Project.new :event_group_id => session[:event_group_id]
    else
      flash[:notice] = "Sorry, you don't have permissions to create a new project."
      redirect_to :controller => "main"
    end
  end
  
  def create
    if (@user.is_projects_coordinator?)
      @project = Project.new(params[:project].merge(:event_group_id => session[:event_group_id]))
      
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        redirect_to :action => 'list'
      else
        render :action => 'new'
      end
    else
      flash[:message] = "Sorry, you don't have permissions to create a new project."
      redirect_to :controller => "main"
    end
  end
    
  def edit
  end
  
  def staff
  end
  
  def update
    if @project.update_attributes(params[:project])
      flash[:notice] = 'Project was successfully updated.'
      redirect_to :action => 'show', :id => @project
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @eg.projects.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def set_prefix
    @role = params[:role]
  end
  
  def search
    # find viewers (now we don't need just staff, this is so we can add interns
    #  to roles) and not already {role}
    # for this project
    
    @role_staff_ids = @project.send(@role).find(:all).collect { |staff| staff.viewer_id }

    @phrase = "%" + params[:search_text].gsub(' ', '%') + "%"
    select = "#{Viewer.table_name}.viewer_userID, #{Person.table_name}.person_fname, #{Person.table_name}.person_lname"

    match_by_userID = Viewer.find(:all, :include => :persons, :conditions => ["viewer_userID like ?", @phrase], :select => select)
    match_by_name = Viewer.find(:all, :include => :persons, 
    	:conditions => [ "person_fname like ? or person_lname like ?", @phrase, @phrase ],
	:select => select
    )
    
    # remove those that already have roles, and duplicates
    @have_viewer = {}
    delete_proc = Proc.new { |v|
      if @role_staff_ids.include?(v.viewer_id) || @have_viewer[v.viewer_id]
        true
      else
        @have_viewer[v.viewer_id] = true
        false
      end
    }
    match_by_userID.delete_if &delete_proc
    match_by_name.delete_if &delete_proc

    @found_viewers = match_by_userID + match_by_name
    
    render :action => "roles/search_results", :layout => "empty"
  end
  
  def add
    viewer = Viewer.find(params[:viewer_id])
    
    table = @role.singularize.camelize.constantize
    @success = table.create :viewer_id => params[:viewer_id], :project_id => params[:project_id]

    if table == ProjectStaff || table == ProjectDirector || table == ProjectAdministrator
      @profile = Profile.find_by_viewer_id_and_project_id params[:viewer_id], params[:project_id]
      if @profile.nil?
        @profile = StaffProfile.create :viewer_id => params[:viewer_id], :project_id => params[:project_id]
      elsif @profile.class != StaffProfile
        @profile.manual_update :type => StaffProfile, :user => @user
      end

      @success = @success && @profile
    end

    unless @success
      flash[:error] = "Sorry, there was an error adding #{viewer.viewer_userID} as project staff for \"#{@project.title}\".  You should let the system administrator know about this."
    end
    
    render :partial => "roles/list", :layout => false
  end
  
  def remove
    viewer = Viewer.find(params[:viewer_id])
    
    @success = @role.singularize.camelize.constantize.destroy_all [ "viewer_id = ? and project_id = ?",
                              viewer.id, @project.id ]
    unless @success
      flash[:error] = "Sorry, there was an error removing #{viewer.viewer_userID} from \"#{@project.title}\" project staff.  You should let the system administrator know about this."
    else
      # now set the staff profile to a withdrawn
      @profile = Profile.find_by_viewer_id_and_project_id viewer.id, @project.id
      if @profile && no_assignments(:staff_viewer => viewer, :project => @project)
        @profile = StaffProfile.find_by_viewer_id_and_project_id viewer.id, @project.id

        # if 'going' has been unchecked, the staff profile is set to withdrawn
        @profile ||= Withdrawn.find_by_viewer_id_and_project_id viewer.id, @project.id

        @profile.manual_update :type => Withdrawn, :status => :staff_profile_dropped, :user => @user
      end
    end
  
    render :partial => "roles/list", :layout => false
  end

  def no_assignments(params)
    for role in [ Processor, SupportCoach, ProjectStaff, ProjectDirector, ProjectAdministrator ]
      return false if role.find_by_viewer_id_and_project_id(params[:staff_viewer].id, params[:project].id)
    end
    return true
  end
end

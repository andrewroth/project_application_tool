require_dependency 'permissions'

class ProfilesController < ApplicationController
  include Permissions
  #cache_sweeper :profiles_sweeper, :only => [ :create, :update ]

  INFO_ACTIONS = [ :crisis_info, :update_crisis_info, :campus_info, :update_campus_info, :campus_info_new ]

  skip_before_filter :restrict_students, :only => [ :index, :list, :view, :update, 
                                              :travel, :support_received, :costing, :prep_items, :update_support ] + INFO_ACTIONS
                                              
  before_filter :set_title
  before_filter :get_profile, :except => [ :index, :list, :set_profile_going, :new, :create ] + INFO_ACTIONS
  before_filter :ensure_profile_ownership, :except => [ :view, :index, :list, :update, :set_profile_going, 
                                                        :class_options, :new, :viewer_id_dropdown, :populate_applications, :create ] + INFO_ACTIONS
  before_filter :ensure_profile_ownership_or_eventgroup_coordinator, :only => [ :view, :update ]
  before_filter :ensure_projects_coordinator, :only => [ :new, :create ]

  def viewer_id_dropdown
    filter_s = params[:viewer]
    filters = filter_s.split(' ')
    
    if filters.size > 2
      filters = [ filters.delete_at(0), filters.join(' ') ]
    end

    conditions = if filters.size == 1
        filter = filters.first
        [ 'person_fname like ? or person_lname like ?', "%#{filter}%", "%#{filter}%" ]
      elsif filters.size == 2
        filter_1, filter_2 = filters
	filter_2.gsub!(' ','%')
        [ '(person_fname like ? and person_lname like ?) or (person_fname like ? or person_lname like ?)', 
             "%#{filter_1}%", "%#{filter_2}%", "%#{filter_s}%", "%#{filter_s}%" ]
      end

    ps = Person.find :all, :conditions => conditions,
         :include => :viewers, :order => [ 'person_lname, person_fname' ]

    vs = Viewer.find :all, :conditions => [ 'viewer_userID like ? ', "%#{filter_s}%" ]

    @viewers = ps.collect(&:viewers).flatten + vs
    @viewers.uniq!
  end

  def create
    @profile = Profile.create

    # make new app if necessary
    if params[:profile][:appln_id] == 'new'
       form = @eg.forms.find_by_hidden(false)
       @appln = Appln.create :form_id => form.id,
         :viewer_id => params[:profile][:viewer_id]
       params[:profile][:appln_id] = @appln.id
    end

    success = @profile.manual_update(params[:profile], @viewer)
    @profile.reload

    flash[:notice] = "Created new profile for #{@profile.viewer.name}."

    redirect_to :controller => :tools
  end

  def populate_applications
    begin
      v = Viewer.find params[:viewer_id]
    rescue
      render :inline => "Error: Can't find viewer #{params[:viewer_id]}"
      return
    end

    @applns = v.applns
    @applns.reject!{ |a|
      (a.profile.project && a.profile.project.event_group_id != @eg.id) || (a.form.event_group_id != @eg.id)
    }
  end

  def new
    @profile = Profile.new
  end

  def index
    redirect_to :action => :list
  end
  
  def costing
    @submenu_title = 'costing'
  end

  def travel
    @submenu_title = 'travel'
  end
  
  def prep_items
    @submenu_title = 'paperwork'
  end
  
  def set_profile_going
    viewer = Viewer.find params[:viewer_id]
    project = @eg.projects.find params[:project_id]
    profile = Profile.find_by_viewer_id_and_project_id viewer.id, project.id

    unless is_projects_coordinator_or_projects_administrator(project)
      render :inline => "no permission"
      return false
    end

    if params["viewer_#{viewer.id}_profile_going"] == "1"
      # create
      if profile.nil?
        render :inline => 'created'
        Profile.create :viewer_id => viewer.id, :project_id => project.id
      else
        if profile.class != StaffProfile then
          profile.manual_update :type => StaffProfile, :user => @viewer
          render :inline => 'already created, changed type to StaffProfile'
       else
          render :inline => 'already created, already a StaffProfile'
       end
      end
    else
      # remove
      if !profile.nil?
        profile.manual_update :type => Withdrawn, :status => :staff_profile_dropped, :user => @viewer
        render :inline => 'withdrawn'
      else
        render :inline => 'tried to withdraw, but didn\'t exist'
      end
    end
  end

  def update
    success = @profile.manual_update(params[:profile], @viewer)
    
    if !request.xml_http_request?
      @profile.viewer_id ||= @profile.appln.viewer_id
      flash[:notice] = "Successfully updated #{@profile.viewer.name}'s profile."
      redirect_to :controller => :main, :action => :your_projects, :project_id => original_project_id
    else
      render :inline => (success ? 'success' : 'error')
    end
  end
  
  def list
    @profiles = Profile.find_all_by_viewer_id(@viewer.viewer.id, :include => :project).reject{ |profile|
        profile.project.nil? || profile.project.event_group_id != @eg.id
    }

    @submenu_title = 'Your Profiles'
  end
  
  def campus_info
    @submenu_title = 'Campus Info'
    @person = @appln_person = @viewer.viewer.person
    @assignments = @person.assignments

    render :template => 'assignments/index'
  end

  def crisis_info
    @submenu_title = 'Personal Info and Crisis Info'
    @person = @appln_person = @viewer.viewer.person
    @emerg = @person.emerg
  end
  
  def update_crisis_info # also updates personal info
    @submenu_title = 'Personal Info and Crisis Info'

    @person = @appln_person = @viewer.viewer.person

    success_p = PersonalInformation.save_from_params @person, params
    success_c = CrisisInformation.save_from_params @person, params

    if success_p && success_p
      flash[:notify] = 'Successfully updated your crisis info.'
    else
      flash[:notify] = 'There was an error updating your crisis info.  Please try again.'
    end

    crisis_info
    render :action => 'crisis_info'
  end

  def support_received
    @submenu_title = "support received"
    @donations = @profile.donations
  end

  def view
    flash[:error] = 'It is extremely important that you do not simply print off your 
	  travel page from this website. Please click a link that says "printable itinerary pdf" 
	  such as the one below or the one on the travel page and print your travel information 
	  from Adobe Acrobat Reader. If you do not have Adobe Acrobat Reader it is available for free 
	  <a href="http://www.adobe.com/products/acrobat/readstep2.html" target="_blank">here</a>.'
    @submenu_title = "misc"
  end

  def update_support
    @profile.support_claimed = params[:profile][:support_claimed]
    @profile.support_claimed_updated_at = Time.now
    if @profile.save!
      flash[:notice] = 'Support amount was successfully updated.'
    end
    redirect_to :action => :view, :id => @profile.id
  end

  protected
    def set_title() @page_title = "Profiles" end
    def get_profile() @profile = Profile.find params[:id] if params[:id] end
end

require_dependency 'permissions'

class ProfilesController < ApplicationController
  include Permissions
  #cache_sweeper :profiles_sweeper, :only => [ :create, :update ]

  INFO_ACTIONS = [ :crisis_info, :update_crisis_info, :campus_info, :update_campus_info, :campus_info_new ]

  skip_before_filter :restrict_students, :only => [ :index, :list, :show, :old_dashboard, :view, :update, 
                                              :travel, :support_received, :costing, :paperwork, :update_support, 
                                              :use_past_appln, :set_profile_support_claimed_currency ] + 
                                              INFO_ACTIONS
                                              
  before_filter :set_title
  before_filter :get_profile, :except => [ :index, :list, :set_profile_going, :new, :create ] + INFO_ACTIONS
  before_filter :ensure_profile_ownership, :except => [ :view, :index, :list, :update, :set_profile_going, 
                                                        :class_options, :new, :viewer_id_dropdown, :populate_applications, :create ] + INFO_ACTIONS
  before_filter :set_subject, :only => INFO_ACTIONS
  before_filter :ensure_self_or_eventgroup_coordinator, :only => INFO_ACTIONS
  before_filter :ensure_profile_ownership_or_eventgroup_coordinator, :only => [ :view, :update ]
  before_filter :ensure_eventgroup_coordinator, :only => [ :new, :create ]

  in_place_edit_for :profile, :support_claimed_currency

  def viewer_id_dropdown
    filter_s = params[:viewer]
    filters = filter_s.split(' ')
    
    if filters.size > 2
      filters = [ filters.delete_at(0), filters.join(' ') ]
    end

    conditions = if filters.size == 1
        filter = filters.first
        [ "#{Person._(:preferred_first_name)} like ? or #{Person._(:last_name)} like ?", "%#{filter}%", "%#{filter}%" ]
      elsif filters.size == 2
        filter_1, filter_2 = filters
	filter_2.gsub!(' ','%')
        [ "(#{Person._(:preferred_first_name)} like ? and #{Person._(:last_name)} like ?) or (#{Person._(:preferred_first_name)} like ? or #{Person._(:last_name)} like ?)", 
             "%#{filter_1}%", "%#{filter_2}%", "%#{filter_s}%", "%#{filter_s}%" ]
      end

    ps = Person.find :all, :conditions => conditions,
         :include => :users, :order => [ "#{Person._(:last_name)}, #{Person._(:preferred_first_name)}" ]

    vs = Viewer.find :all, :conditions => [ "#{Viewer._(:username)} like ? ", "%#{filter_s}%" ]

    @viewers = ps.collect(&:viewers).flatten.compact + vs
    @viewers.uniq!
  end

  def create
    unless params[:profile][:viewer_id].present?
      @profile = Profile.new
      @profile.errors.add_to_base "no person chosen"
      render :action => :new
      return
    end

    @profile = Profile.create

    # make new app if necessary
    if params[:profile][:appln_id] == 'new'
       form = @eg.application_form
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
    @applns.find_all{ |a|
      a.profiles.detect{ |profile| profile.project && profile.project.event_group_id == @eg.id } ||
        a.form.event_group_id == @eg.id
    }
  end

  def new
    @profile = Profile.new
  end

  def index
    @page_title = "Dashboard"
    profiles = @viewer.profiles.find :all, :include => [ { :appln => { :form => :questionnaire } }, :project ],
       :select => "#{Profile.table_name}.id, #{Form.table_name}.event_group_id," +
                  "#{Profile.table_name}.status, #{Profile.table_name}.type," +
                  "#{Questionnaire.table_name}.title, #{Project.table_name}.title",
       :conditions => [ "#{Form.table_name}.event_group_id = ?", @eg.id ]

    @started = find_profiles profiles, :class => Applying, :status => :started
    @unsubmitted = find_profiles profiles, :class => Applying, :status => :unsubmitted
    @submitted = find_profiles profiles, :class => Applying, :status => :submitted
    @completed = find_profiles profiles, :class => Applying, :status => :completed
    @withdrawn = find_profiles profiles, :class => Withdrawn
    @acceptances = find_profiles profiles, :class => Acceptance

    if @eg.allows_multiple_applications_with_same_form
      @already_have_forms = profiles.collect{ |p| p.appln.form if p.appln.form }.compact
      @not_started = @eg.forms.find_all_by_hidden(false)
    else
      # get all possible forms
      all_form_ids = @eg.forms.find_all_by_hidden(false).collect &:id

      # now figure out which haven't been started (easy)
      not_started_ids = all_form_ids - profiles.collect{ |p| p.appln.form.id if p.appln.form }.compact

      @not_started = Form.find(not_started_ids)
    end

    # special case when there's one acceptance -- forward to the your apps acceptance page
    if @started.empty? && @unsubmitted.empty? && @submitted.empty? &&
      @completed.empty? && @withdrawn.empty? && @acceptances.length == 1
      redirect_to({ :controller => 'profiles', :action => 'show', :id => @acceptances.first.id })
    end
  end
  
  # TODO move to new action
  def continue
    redirect_to :controller => :appln, :profile_id => @profile.id
  end

  # TODO move to new action
  def start
    # make sure the form is in this event group
    form = @eg.forms.find params[:form_id]

    # look for ane already
    appln = @viewer.applns.find_by_form_id(form.id)
    if appln && !@eg.allows_multiple_applications_with_same_form
      @profile = appln.profile
    else
      appln = Appln.create :form_id => form.id,
            :viewer_id => @viewer.id,
            :status => "started"

      # might as well give them a profile right now, and set the viewer up properly too
      @profile = appln.profile
      @profile.viewer_id = @viewer.id
      @profile.project = @eg.projects.first if @eg.projects.count == 1
      @profile.save!

      # and set the pref 1 if there's only one project
      if @eg.projects.size == 1
        pid = @eg.projects.first.id
        appln.preference1_id = pid
        appln.preference2_id = pid
        appln.save!

        @profile.project_id = pid
        @profile.save!
      end
    end

    redirect_to :controller => :appln, :profile_id => @profile.id
  end
 
  def costing
    @submenu_title = 'costing'
  end

  def travel
    @submenu_title = 'travel'
  end
  
  def paperwork
    @submenu_title = 'todos'
  end
  
  def set_profile_going
    viewer = Viewer.find params[:viewer_id]
    project = @eg.projects.find params[:project_id]
    profile = Profile.find_by_viewer_id_and_project_id viewer.id, project.id

    unless is_eventgroup_coordinator_or_projects_administrator(project)
      render :inline => "no permission"
      return false
    end

    if params["viewer_#{viewer.id}_profile_going"] == "1"
      # create
      if profile.nil?
        render :inline => 'created'
        StaffProfile.create :viewer_id => viewer.id, :project_id => project.id
      else
        if profile.class != StaffProfile then
          profile.manual_update :type => StaffProfile, :viewer => @viewer
          render :inline => 'already created, changed type to StaffProfile'
       else
          render :inline => 'already created, already a StaffProfile'
       end
      end
    else
      # remove
      if !profile.nil?
        profile.manual_update :type => Withdrawn, :status => :staff_profile_dropped, :viewer => @viewer
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
  
  def campus_info
    @page_title = "Profile"
    @appln_person = @viewer.person
    @submenu_title = 'Campus Info'
  end

  def update_campus_info
    if CampusInformation.save_from_params(@viewer.person, params)
      flash[:notice] = "Campus info updated"
    else
      flash[:notice] = "Not enough information to set your campus info"
    end
    redirect_to :action => :campus_info
  end

  def crisis_info
    @page_title = "Profile"
    @submenu_title = 'Personal Info and Crisis Info'
    @person = @appln_person = @subject.person
    @emerg = @person.get_emerg
  end
  
  def update_crisis_info # also updates personal info
    @submenu_title = 'Personal Info and Crisis Info'

    @subject_person = @appln_person = @subject.person

    success_p = PersonalInformation.save_from_params @subject_person, params
    success_c = CrisisInformation.save_from_params @subject_person, params

    if success_p && success_p
      subject_name = @subject_person == @person ? "your" : @subject_person.full_name
      flash[:notify] = "Successfully updated #{subject_name} crisis info."
    else
      flash[:notify] = "There was an error updating your crisis info.  Please try again."
    end

    crisis_info
    render :action => 'crisis_info'
  end

  def support_received
    @submenu_title = "support received"
    @donations = @profile.donations
  end

  # support view for backwards compatibility
  def view
    redirect_to :action => :show
  end

  def andrew_show
    show
  end

  def show
    @page_title = "Dashboard"
  end

  def old_dashboard
    flash[:error] = 'It is extremely important that you do not simply print off your 
	  travel page from this website. Please click a link that says "printable itinerary pdf" 
	  such as the one below or the one on the travel page and print your travel information 
	  from Adobe Acrobat Reader. If you do not have Adobe Acrobat Reader it is available for free 
	  <a href="http://www.adobe.com/products/acrobat/readstep2.html" target="_blank">here</a>.'
    @submenu_title = "old dashboard"
  end

  def update_support
    @profile.support_claimed = params[:profile][:support_claimed]
    @profile.support_claimed_updated_at = Time.now
    if @profile.save!
      flash[:notice] = 'Support amount was successfully updated.'
    end
    redirect_to :action => :view, :id => @profile.id
  end

  def use_past_appln
    debugger
    requested_appln = @viewer.applns.find(params[:requested_appln_id])
    if requested_appln.profile.accepted_at < 16.months.ago
      flash[:notice] = "Sorry, that application was accepted too long ago."
    else
      @profile.reuse_appln = requested_appln
      @profile.appln.copy_answers(requested_appln)
      @profile.save!
    end
    redirect_to :controller => :appln, :action => :index, :profile_id => @profile.id
  end

  protected
    def set_title() @page_title = "Dashboard" end
    def get_profile() @profile = Profile.find params[:id] if params[:id] end

    def set_subject
      if params[:viewer_id]
        @subject = Viewer.find params[:viewer_id]
      else
        @subject = @viewer
      end
    end

    def ensure_self_or_eventgroup_coordinator
      unless @subject == @viewer || is_eventgroup_coordinator
        render :inline => "no permission"
      end
    end

    def find_profiles(profiles, o)
      o[:status] = o[:status].to_s if o[:status]

      profiles.find_all{ |p|
        if o[:class] != p.class
          false
        elsif o[:status]
          p.status == o[:status]
        else
          true
        end
      }
    end

end

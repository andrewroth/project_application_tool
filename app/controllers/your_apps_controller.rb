load 'permissions.rb'

class YourAppsController < ApplicationController
  include Permissions

  before_filter :get_viewer
  before_filter :set_acceptance, :only => [ :acceptance ]
  before_filter :set_appln_from_acceptance, :only => [ :acceptance ]
  before_filter :set_appln_from_current_appln, :only => [ :submit ]
  before_filter :user_owns_appln_with_message, :only => [ :acceptance ]
  before_filter :get_or_create_appln, :only => [ :apply, :view_always_editable ]
  before_filter :set_title
  skip_before_filter :restrict_students
  
  def get_viewer
    @viewer = @user.viewer
  end
  
  def index
    redirect_to :action => :list
  end
  
  def find_applns_by_status_and_eg(status)
    @viewer.applns.find_all_by_status(status, :include => :form).reject { |app|
      app.form.event_group_id != @eg.id
    }
  end
  
  def find_applns(params)
    applns = if params[:appln_status]
        @viewer.applns.find_all_by_status(params[:appln_status], :include => :profiles)
      else @viewer.applns
      end
    
    if params[:profile_class]
      applns.reject! { |a| a.profile.class != params[:profile_class] }
    end

    applns.reject! { |a| a.form.nil? || a.form.event_group_id != @eg.id }

    applns
  end

  def list
    @started = find_applns :profile_class => Applying, :appln_status => 'started'
    @unsubmitted = find_applns :profile_class => Applying, :appln_status => 'unsubmitted'
    @submitted = find_applns :profile_class => Applying, :appln_status => 'submitted'
    @completed = find_applns :profile_class => Applying, :appln_status => 'completed'
    @withdrawn = find_applns :profile_class => Withdrawn
    @acceptances = @viewer.profiles.find_all_by_type('Acceptance', :include => :project).reject { |acc|
         acc.project.event_group_id != @eg.id
    }
    @accepted_applns = @acceptances.collect(&:appln).compact
    
    # get the form ids for the different categories
    @unsubmitted_ids = @unsubmitted.collect{ |ap| ap.form.id }
    @submitted_ids = @submitted.collect{ |ap| ap.form.id }
    @completed_ids = @completed.collect{ |ap| ap.form.id }
    @started_ids = @started.collect{ |ap| ap.form.id }
    @withdrawn_ids = @withdrawn.collect{ |ap| ap.form.id }
    @acceptance_ids = @accepted_applns.collect{ |ap| ap.form.id }
    
    # get all possible forms
    @all_ids = @eg.forms.find_all_by_hidden(false).collect &:id
    # now figure out which haven't been started (easy)
    @not_started_ids = @all_ids - @started_ids - @submitted_ids - 
      @completed_ids - @withdrawn_ids - @acceptance_ids - @unsubmitted_ids
    
    @not_started = Form.find(@not_started_ids)
  end
  
  def apply
    redirect_to :controller => :appln, :appln_id => @appln.id
  end

  def view_always_editable
    redirect_to :controller => :appln, :action => 'view_always_editable', :appln_id => @appln.id
  end

  def acceptance
    redirect_to :controller => :profiles, :action => :view, :id => params[:id]
  end
  
  protected
  
    def set_acceptance
      @acceptance = Acceptance.find(params[:id])
    end
    
    def set_appln_from_acceptance
      @appln = @acceptance.appln
    end
    
    def set_appln_from_current_appln
      @appln = @appln
    end
      
    def get_or_create_appln
      if params[:appln_id].nil?
        form = Form.find(params[:id]) # make sure it's valid
        
        # try to find an appln already
        @appln = Appln.find_by_viewer_id_and_form_id(@user.id, form.id)
        if @appln.nil?
          @appln = Appln.create :form_id => form.id,
            :viewer_id => @user.id,
            :status => "started"

	  # might as well give them a profile right now, and set the viewer up properly too
	  @profile = @appln.profile
          @profile.viewer_id = @appln.viewer_id
	  @profile.viewer_id
	  # and set the pref 1 if there's only one project
	  if @eg.projects.size == 1
	    pid = @eg.projects[0].id
	    @appln.preference1_id = pid.id
	    @appln.preference2_id = pid.id
	  end
	  @profile.save!

        end
      else
        @appln = Appln.find params[:appln_id]
      end
      
      true
    end
    
    def set_title
      @page_title = "Your Apps"
    end
end

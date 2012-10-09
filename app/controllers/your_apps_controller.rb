require_dependency 'permissions'

class YourAppsController < ApplicationController
  include Permissions

  cache_sweeper :profiles_sweeper

  before_filter :user_owns_profile_with_message, :only => [ :acceptance, :continue ]
  before_filter :set_title

  skip_before_filter :restrict_students
  
  def index
    redirect_to :action => :list
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

  def list
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
#    @acceptances = @viewer.profiles.find_all_by_type('Acceptance', :include => :project).reject { |acc|
#         acc.project.event_group_id != @eg.id
#    }
#    @accepted_applns = @acceptances.collect(&:appln).compact
    
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
      redirect_to({ :controller => 'appln', :action => 'view_always_editable', :profile_id => @acceptances.first.id })
    end
  end
  
  def continue
    redirect_to :controller => :appln, :profile_id => @profile.id
  end

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

  def view_always_editable
    redirect_to :controller => :appln, :action => 'view_always_editable', :profile_id => @profile.id
  end

  def acceptance
    redirect_to :controller => :profiles, :action => :view, :id => params[:profile_id]
  end
  
  protected
  
    def set_title
      @page_title = "Application"
    end
end

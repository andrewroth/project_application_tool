require 'appln_custom_pages.rb'
require 'permissions.rb'

class ApplnController < InstanceController
  include ApplnCustomPages
  include Permissions

  # applns are scoped by @appln.form.event_group
  skip_before_filter :set_can_view_entire
  skip_before_filter :restrict_students
  
  prepend_before_filter :preview_setup, :only => [ :preview ]

  prepend_before_filter :set_appln_from_ref, :only => [ :delete_reference, :resend_reference_email ]
  skip_before_filter :get_appln, :only => [ :delete_reference, :resend_reference_email ]
  
  before_filter :ensure_appln_ownership_or_processor
  
  def view_always_editable
    @pass_params ||= {}
    @pass_params[:view_always_editable] = true
    index
  end
  
  def preview
    @page_title = "Preview"
    redirect_to :controller => "appln"
  end
  
  def withdrawl_reason
    render
  end
  
  def withdraw
    @appln.profile.withdraw! :status => 'self_withdrawn', :user => @user
    get_page
  end
  
  # VARIOUS HELPERS TO FOLLOW
  
  protected
  
  # overriding from InstanceController
  def get_questionnaire
#    @questionnaire = @appln.form.questionnaire
#    @pages = @questionnaire.pages
    if @appln.nil?
      error = "Couldn't find application id #{params[:appln_id]}"
      render :inline => error
      return false
    end

    @appln.form.questionnaire
  end
  
  # overriding from InstanceController
  def questionnaire_instance
    @appln
  end
  
  def after_save_form
    @appln.save!
  end
  
  def after_submit
    # If we haven't yet done so, send reference invitations
    refs = get_references
    refs.each do |reference|
      reference.send_invitation unless reference.email_sent?
    end
    @appln.profile.submit!
    
    @appln.complete # will try to go into completed for if there are no refs
  end
  
  # custom projects preferences save/display method
  def project_preferences(save = false)
    if save
      #save all the preferences
      if !params[:answers].nil? && params[:answers]["preference1_id"]
        for i in 1..2
          @appln["preference#{i}_id"] = params[:answers]["preference#{i}_id"]
        end
      
	profile = @appln.profile
        profile.project_id = params[:answers]["preference1_id"]
        profile.save!
      end      
      
      # save the intern flag
      if !params["application"].nil?
        @appln["as_intern"] = params["application"]["as_intern"]
      end
    else
      @projects = @appln.form.event_group.projects.find(:all)
    end
  end
  
  def preview_setup
    @appln = Appln.find(:first)
  end
  
  def get_filter
    if params[:view_always_editable]
      # keep passing always editable to save_page and validate_page can find the right pages
      @pass_params[:view_always_editable] = true
      
      @user.set_project @appln.profile.project
      filter = if @user.is_projects_coordinator?
          [ "processor_always_editable", "always_editable" ]
        elsif @user.is_processor?
          [ "processor_always_editable" ]
	else
	  [ "always_editable" ]
        end
      { :filter => filter, :default => false }
    else nil
    end
  end  
  
  def set_appln_from_ref
    @reference = ReferenceInstance.find params[:ref_id]
    @appln = @reference.instance
  end

  def redirect_to_default_view
    redirect_to :controller => :appln, :appln_id => @appln.id
  end

  def get_appln
    super
    @pass_params ||= {}
    @pass_params[:appln_id] = @appln.id if @appln
  end

end

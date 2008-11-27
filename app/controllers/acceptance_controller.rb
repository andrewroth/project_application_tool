require 'appln_admin/modules/acceptance_pile_functionality.rb'

class AcceptanceController < BaseApplnAndRefsViewer
  include AcceptancePileFunctionality
  include Permissions
  
  before_filter :ensure_view_summary_permission, :only => [ :view_summary ]
  before_filter :ensure_view_entire_permission, :only => [ :view_entire, :summary_forms ]
  before_filter :ensure_view_references_permission, :only => [ :view_entire ]
  before_filter :ensure_modify_acceptance_permission, :only => [ :update_support_coach ]
  before_filter :set_readonly
  skip_before_filter :set_questionnaire, :only => [ :bulk_summary_forms ]
  skip_before_filter :setup, :only => [ :bulk_summary_forms ]
  prepend_before_filter :set_project, :only => [ :bulk_summary_forms ]
  prepend_before_filter :set_questionnaire_manually, :only => [ :bulk_summary_forms ]

  def submit
    flash[:notice] = "Sorry, only students can submit applications.  If you need to change an applications status, you can do it with the move/withdraw link if you have sufficient access permissions.  If you don't, email the contact email and you should be able to."
    redirect_to :back
  end

  def bulk_summary_forms
    @page_title = "Acceptance Summary Forms"

    params[:summary] = true
    bulk_acceptance_forms([ :appln, { :viewer => :persons } ]) do |acc|
      @instances << { :instance => acc.appln,
                      :appln => acc.appln,
                      :title => "#{acc.viewer.name} Summary Form"
                    }
    end
  end

  def delete_reference
    flash[:error] = "Sorry, only the student can delete references.  If you really want this done, email the technical inquiries email below."
    redirect_to :back
  end

  def view_summary
    @submenu_title = submenu_title + " Summary"
    @pass_params ||= {}
    @pass_params[:summary] = true
    @pass_params[:parent_action] = 'view_summary' 
    @form_title = @appln.viewer.name + " Summary"
    index
  end

  def update_intern_status
    @profile.as_intern = @profile.as_intern ? false : true
    @profile.save!
    if !request.xml_http_request?
      redirect_to :controller => :main, :action => :your_projects
    else
      render :file => 'acceptance/update_intern_status', :use_full_path => true
    end
  end
  
  def update_support_coach
    if params[:support_coach_id] == Acceptance.support_coach_none
      @profile.support_coach_id = nil
    else
      @profile.support_coach_id = params[:support_coach_id]
    end
    @profile.save!
    if !request.xml_http_request?
      redirect_to :controller => "main", :action => "your_projects"
    else
      render :inline => "success"
    end
  end
  
  protected
  
  def set_questionnaire_manually
     # unfortunately a hack, I need this done before this method, but this method
        # needs to be done before the engine filters
        # If I call appl's directly, I get the stupid 
        # A copy of ApplicationController has been removed from the module tree but is still active!
    @eg = EventGroup.find session[:event_group_id]

    form = @eg.forms.find_by_hidden false # params[:form_id]
    @questionnaire = form.questionnaire
  end

  def ensure_view_summary_permission
    @user.set_project(@project)

    render :inline => "no permission" unless @user.is_projects_coordinator? || 
      @user.is_processor? || @user.is_project_director? || @user.is_project_administrator? ||
      @user.is_project_staff? || @user.is_support_coach?
  end
  
  def ensure_modify_acceptance_permission
    @user.set_project(@project)
    
    unless @user.is_projects_coordinator? || @user.is_processor? || 
      @user.is_project_director? || @user.is_project_administrator?
      render :inline => "No permission"
    end
  end

  def set_title() @page_title = "App Processing" end
  
  def get_filter
    if params[:action] == 'view_summary' || params[:action] == 'bulk_summary_forms' || params[:summary]
      { :filter => [ "in_summary_view" ], :default => false }
    else
      super
    end
  end

  def set_readonly() @custom_folder = "readonly" end
end

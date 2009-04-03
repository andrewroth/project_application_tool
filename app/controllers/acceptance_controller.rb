require_dependency 'appln_admin/modules/acceptance_pile_functionality.rb'

class AcceptanceController < ApplicationController
  include Permissions
  
  before_filter :ensure_modify_acceptance_permission, :only => [ :update_support_coach ]

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
  
  def ensure_modify_acceptance_permission
    @project = @profile.project
    @viewer.set_project(@project)
    
    unless @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_processor? || 
      @viewer.is_project_director? || @viewer.is_project_administrator?
      render :inline => "No permission"
    end
  end

  def set_title() @page_title = "App Processing" end
end

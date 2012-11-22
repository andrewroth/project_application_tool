require_dependency 'permissions'

class ProcessorController < ApplicationController
  include Permissions
  
  before_filter :get_profile_and_project
  before_filter :set_view_permissions
  before_filter :set_references
  before_filter :ensure_evaluate_permission
  
  def actions
    @project = @profile.project
    @questionnaire = @eg.forms.find_by_name("Processor Form").questionnaire
    @invalid_pages = []
    @questionnaire.pages.each do |page|
      @invalid_pages << page unless page.validated?(@appln.processor_form)
    end
    @submenu_title = "Actions"
  end
  
  # locks a processor entry, then goes to evaluate view
  def evaluate
    if @profile.locked_by == @viewer
      redirect_to :controller => 'profiles_viewer', :id => @profile.id, :action => 'entire'
      return
    elsif @profile[:locked_by]
      redirect_to :action => 'actions', :profile_id => @profile.id
      return
    end

    # lock
    @profile[:locked_by] = @viewer.id
    @profile.save!
    
    redirect_to :controller => :profiles_viewer, :action => :entire, :id => @profile.id
  end
  
  def release
    # unlock
    @profile.locked_by = nil
    @profile.save!
    
    redirect_to :controller => "main", :action => "your_applications"
    flash[:notice] = "You are no longer marked as evaluating " + @appln.viewer.name + "'s application."
  end
  
  def accept
    @appln.profile.manual_update :type => 'Acceptance', :appln_id => @appln.id, :project_id => @project.id, 
      :support_claimed => 0, :support_coach_id => params[:support_coach_id], 
      :accepted_by_viewer_id => @viewer.id, :as_intern => params[:as_intern],
      :viewer_id => @appln.viewer_id, :viewer => @viewer, :locked_by => nil
    
    profile = Profile.find(@appln.profile.id) # reload to make the new type catch
    profile.accept!

    SpApplicationMailer.deliver_accepted(profile, @viewer.email)
    SpApplicationMailer.deliver_profile_accepted(profile)

    flash[:notice] = "#{@appln.viewer.name} accepted to #{@project.title}"
    redirect_to :controller => "main", :action => "your_projects"
  end
  
  def decline
    @profile.manual_update :type => 'Withdrawn', :status => 'declined',
      :viewer => @viewer
    
    flash[:notice] = "#{@appln.viewer.name} declined"
    redirect_to :controller => "main", :action => "your_projects"
  end
  
  def forward
    @project = @eg.projects.find(params[:forward_to_project_id])
    @profile.project = @project
    
    @profile.locked_by = nil
    @profile.save!
    
    flash[:notice] = "#{@appln.viewer.name} forwarded to #{@project.title}"
    redirect_to :controller => "main", :action => "your_projects"
  end
  
  protected
  
  def set_title() @page_title = "App Processing" end

  def ensure_evaluate_permission
    @viewer.set_project(@project)
    unless (@viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_processor?)
      flash[:notice] = "Sorry, you don't have permissions to evaluate applications."
      render :text => "", :layout => true
      return false
    end
    return true
  end

  def get_profile_and_project
    @profile = Profile.find params[:profile_id]
    @project = @profile.project
    @viewer.set_project @project
  end

  def set_references() @references = @appln.references_text_list end
end

require_dependency 'permissions'

class ReferencesViewerController < BaseViewController
  include Permissions

  ProjectsCoordinator

  prepend_before_filter :set_view_permissions # run this before ensure_permission
  prepend_before_filter :get_reference_instance # prepend so that QE methods (see below) don't fail
  prepend_before_filter :set_user # run this before set_view_permissions since permissions depend on user
  before_filter :ensure_permission
  before_filter :set_references
  skip_before_filter :get_profile_and_appln

  def show
    @submenu_title = @reference.text

    # pass the reference_instance, not the profile_id
    @pass_params ||= {}
    @pass_params[:profile_id] = nil
    @pass_params[:id] = @reference_instance.id

    index
  end

  protected

    def get_reference_instance
      debugger
      @reference_instance = ReferenceInstance.find params[:id]
      @reference = @reference_instance.reference
      @appln = @reference_instance.instance
      @profile = @appln.profile
      @project = @profile.project
      @eg = @project.event_group
    end

    def ensure_permission
      unless @can_view_references
        flash[:notice] = "Sorry, you don't have permission to view references for this project."
        redirect_after_denied
      end
    end

    ### questionnaire methods
  
    def get_filter() nil end

    def questionnaire_instance
      @instance = @reference_instance
    end

    def get_questionnaire
      @reference.questionnaire
    end

    ### end questionnaire methods
end 

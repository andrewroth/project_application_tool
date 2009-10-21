require_dependency 'permissions'

class ReferencesViewerController < ViewOnlineController
  include Permissions

  ProjectsCoordinator

  prepend_before_filter :set_view_permissions # run this before ensure_permission
  prepend_before_filter :get_reference_instance # prepend so that QE methods (see below) don't fail
  prepend_before_filter :set_user # run this before set_view_permissions since permissions depend on user
  before_filter :ensure_permission
  before_filter :set_references
  skip_before_filter :get_profile_and_appln

  def set_custom_folder
    @custom_folder = 'readonly'
  end

  def show
    @submenu_title = @reference.text

    # pass the reference_id as well as id, since on questionnaire methods, the id passed
    # is the page id
    @pass_params ||= {}
    @pass_params[:reference_instance_id] = @reference_instance.id
    @pass_params[:id] = @reference_instance.id

    index
  end

  protected

    def get_reference_instance
      @reference_instance = ReferenceInstance.find params[:reference_instance_id] || params[:id]
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
  
    def get_filter()
      if @can_view_confidential
        { }
      else
        { :filter => ['confidential'], :default => true }
      end
    end

    def questionnaire_instance
      @instance = @reference_instance
    end

    def get_questionnaire
      @reference.questionnaire
    end

    ### end questionnaire methods
end 

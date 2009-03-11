class ProfilesViewerController < ViewOnlineController
  include Permissions

  ProjectsCoordinator

  prepend_before_filter :set_view_permissions # run this before any permissions
  prepend_before_filter :get_profile # prepend so that QE methods don't fail
  prepend_before_filter :set_user # run this before set_view_permissions since permissions depend on user
  before_filter :ensure_permission, :only => [ :entire, :summary ]
  before_filter :set_references

  def show
    # go somewhere appropriate
    redirect_to @can_view_entire ? 
      entire_profiles_viewer_url(@profile) : summary_profiles_viewer_url(@profile)
  end

  def entire
    @debug = @can_view_references.inspect
    @submenu_title = 'View Appln'
    index
  end

  def summary
     @submenu_title = 'View Appln Summary'
    index
  end

  protected

    def ensure_permission
      unless instance_variable_get("@can_view_#{params[:action]}")
        flash[:notice] = "Sorry, you don't have permission for this action."
        redirect_after_denied
      end
    end

    ### questionnaire methods
  
    def get_filter
      if %w(summary bulk_summary_forms).include? params[:action]
        { :filter => [ "in_summary_view" ], :default => false }
      elsif %w(entire).include? params[:action]
        { :filter => ['confidential'], :default => true }
      end
    end

    def questionnaire_instance
      @instance = @profile.appln
    end

    def get_questionnaire
      @questionnaire = @profile.appln.form.questionnaire
    end

    ### end questionnaire methods
end 

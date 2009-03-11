require_dependency 'permissions'

class ProcessorViewerController < BaseViewController
  include Permissions

  ProjectsCoordinator

  prepend_before_filter :set_view_permissions # run this before any permissions
  prepend_before_filter :get_profile # prepend so that QE methods don't fail
  prepend_before_filter :set_user # run this before set_view_permissions since permissions depend on user
  before_filter :ensure_permission
  before_filter :set_references

  def show
    @submenu_title = 'Processor Form'
    index
  end

  protected

    def ensure_permission
      unless @can_view_entire
        flash[:notice] = "Sorry, you don't have permission to view references."
        redirect_after_denied
      end
    end

    ### questionnaire methods
  
    def get_filter
      # show confidential questions only for processors and eventgroup coordinators
      # when not doing bulk processor forms and not in the pdf form view (why was the
      # @pdf check added? I forget)
      if !@pdf && !@for_pdf && !(params[:action] == 'bulk_processor_form') &&
        (@user.is_eventgroup_coordinator? || @user.is_processor?)
        nil
      else
       { :filter => ['confidential'], :default => true } 
      end
    end

    def questionnaire_instance
      @appln.processor_form
    end

    def get_questionnaire
      @questionnaire = @eg.forms.find_by_name("Processor Form").questionnaire
    end

    ### end questionnaire methods
end 

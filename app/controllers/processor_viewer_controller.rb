require_dependency 'permissions'

class ProcessorViewerController < InstanceController
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
        if request.xhr?
          render(:update) { |page| page.alert("Sorry, no permission for this action.") }
        else
          flash[:notice] = "Sorry, you don't have permission to view references."
          redirect_after_denied
        end
      end
    end

    ### questionnaire methods
  
    def get_filter
      # show confidential questions only for processors and eventgroup coordinators
      # when not doing bulk processor forms and not in the pdf form view (why was the
      # @pdf check added? I forget)
      if !@pdf && !@for_pdf && !(params[:action] == 'bulk_processor_form') &&
        (@viewer.is_eventgroup_coordinator?(eg) || (@viewer.set_project(@project) && @viewer.is_processor?))
        nil
      elsif @can_view_confidential
        nil
      else
        { :filter => ['confidential'], :default => true } 
      end
    end

    def questionnaire_instance
      @appln.processor_form
    end

    def get_questionnaire
      @questionnaire = eg.forms.find_by_name("Processor Form").questionnaire
    end

    def eg
      # use the event group of the appln itself if possible
      @eg2 ||= @appln.try(:profile).try(:event_group) || @eg
    end

    ### end questionnaire methods
end 

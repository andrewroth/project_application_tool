# my extensions to the QE

require_dependency 'vendor/plugins/questionnaire_engine/app/controllers/base_view_controller.rb'

require_dependency 'questionnaire_engine/form_loading_indicator.rb'
require_dependency 'questionnaire_engine/bulk_printing.rb'
require_dependency 'questionnaire_engine/form_printing.rb'

class BaseViewController < ApplicationController
  include FormLoadingIndicator
  include BulkPrinting
  include FormPrinting

  protected

    def set_references() @references = @appln.references_text_list end
    
    # finds a good page to redirect to after denying permission
    def redirect_after_denied
      # go back to the next best spot
      if @profile
        redirect_to profiles_viewer_url(@profile.id)
      else
        redirect_to :controller => :main
      end
    end

    def get_profile
      @profile = Profile.find params[:id]
      @project = @profile.project
      @appln = @profile.appln
    end
end

# my extensions to the QE
require 'questionnaire_engine/form_loading_indicator.rb'
require 'questionnaire_engine/bulk_printing.rb'
require 'questionnaire_engine/form_printing.rb'

class BaseViewController < ApplicationController
  include FormLoadingIndicator
  include BulkPrinting
  include FormPrinting

  before_filter :set_can_view_entire
  before_filter :set_can_view_summary
  before_filter :set_can_view_references
  
  def set_project
    @project = Project.find params[:project_id]
  end
end

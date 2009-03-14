require_dependency 'permissions'
require_dependency 'questionnaire_engine/bulk_printing'

class ProjectsController < ApplicationController
  include Permissions
  include BulkPrinting

  before_filter :get_project
  before_filter :ensure_project_staff
  
  def bulk_summary_forms
    form = @eg.forms.find_by_hidden false # params[:form_id]
    @questionnaire = form.questionnaire
    @questionnaire.filter = { :filter => [ "in_summary_view" ], :default => false }
    @pages = @questionnaire.pages
    @page_title = "Acceptance Summary Forms"

    params[:summary] = true
    bulk_acceptance_forms([ :appln, { :viewer => :persons } ]) do |acc|
      @instances << { :instance => acc.appln,
        :appln => acc.appln,
        :title => "#{acc.viewer.name} Summary Form"
      }
    end
  end

  protected
    
    def get_project
      @project = Project.find params[:id]
    end
end

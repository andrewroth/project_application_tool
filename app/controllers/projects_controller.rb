require_dependency 'permissions'
require_dependency 'questionnaire_engine/bulk_printing'

class ProjectsController < ApplicationController
  include Permissions
  include BulkPrinting

  before_filter :get_project
  before_filter :ensure_project_staff
  
  def bulk_summary_forms
    @page_title = "Acceptance Summary Forms"
    form = @eg.forms.find_by_hidden false # params[:form_id]
    @questionnaire = form.questionnaire
    @questionnaire.filter = { :filter => [ "in_summary_view" ], :default => false }
    @pages = @questionnaire.pages

    params[:summary] = true
    bulk_acceptance_forms([ :appln, { :viewer => :persons } ]) do |acc|
      @instances << { :instance => acc.appln,
        :appln => acc.appln,
        :title => "#{acc.viewer.name} Summary Form"
      }
    end
  end

  def bulk_processor_forms
    @page_title = "Acceptance Processor Forms"
    @questionnaire = @eg.forms.find_by_name("Processor Form").questionnaire

    # filter confidential qs out unless user has permission
    @viewer.set_project @project
    unless @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_processor?
      @questionnaire.filter = { :filter => ['confidential'], :default => true }
    end

    # now that filter is set, get all pages
    @pages = @questionnaire.pages

    bulk_acceptance_forms([ :appln, { :viewer => :persons } ]) do |acc|
      @instances << { :instance => acc.appln.processor_form,
        :title => "#{acc.viewer.name} Processor Form",
        :appln => acc.appln
      }
    end
  end

  protected
    
    def get_project
      @project = Project.find params[:id]
    end
end

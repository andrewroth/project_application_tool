require 'appln_admin/modules/processor_pile_functionality.rb'
require 'appln_admin/modules/acceptance_pile_functionality.rb'

class ProcessorFormController < InstanceController
  include ProcessorPileFunctionality
  include AcceptancePileFunctionality
  include Permissions
  
  skip_before_filter :get_appln
  prepend_before_filter :setup # make sure this runs before anything else, 
                               # as it sets up @appln and @project
  prepend_before_filter :set_project, :only => [ :bulk_processor_forms ]
  before_filter :ensure_permission_processor_forms
  before_filter :ensure_view_entire_permission, :only => [ :index ]
  before_filter :ensure_view_references_permission, :only => [ :index ]
  before_filter :set_submenu
  before_filter :set_title
  before_filter :set_can_view_entire
  skip_before_filter :set_instance, :only => [ :bulk_processor_forms ]
  skip_before_filter :setup, :only => [ :bulk_processor_forms ]
  
  def bulk_processor_forms
    @page_title = "Acceptance Processor Forms"

    bulk_acceptance_forms([ { :appln => :processor_form }, { :viewer => :persons } ]) do |acc|
      @instances << { :instance => acc.appln.processor_form,
                      :title => "#{acc.viewer.name} Processor Form"
                    }
    end
  end
  
  protected
  
  def get_questionnaire
    @questionnaire = @eg.forms.find_by_name("Processor Form").questionnaire
  end
  
  def get_filter
    @user.set_project @project
    return (if !@pdf && !@for_pdf && !(params[:action] == 'bulk_processor_form') && 
        (@user.is_projects_coordinator? || @user.is_processor?)
      nil else { :filter => ['confidential'], :default => true } end
      )
  end

  def questionnaire_instance
    @appln.processor_form
  end
  
  def ensure_permission_processor_forms
    case params[:pile]
    when 'processor'
      return ensure_evaluate_permission
    when 'acceptance'
      return @can_view_entire
    end
    
    if params[:action] == 'bulk_processor_forms'
      ensure_project_director_or_administrator(@project)
    end
  end
  
  def set_title() 
    return "" if @appln.nil?
    @page_title = 'App Processing'
    @form_title = @appln.viewer.name + (" (#{@appln.viewer.person.campus.campus_desc})" if @appln.viewer.person && @appln.viewer.person.campus).to_s + " Processor Form"
  end
  
  def set_submenu
    @submenu_title = 'Processor Form'
  end
  
end

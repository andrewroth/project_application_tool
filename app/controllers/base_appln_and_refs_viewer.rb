# controllers that view the application and/or refs
# should extend this class.  they should be read-only
# and not modify the appln/ref

require_dependency 'appln_admin/modules/view_custom_pages.rb'

class BaseApplnAndRefsViewer < ViewOnlineController
  prepend_before_filter :setup
  before_filter :set_title
  before_filter :set_menu
  skip_before_filter :get_profile_and_appln # done in set in setup, and setup needs to be done really early
  before_filter :get_current_page, :only => [ :view_entire, :view_summary ]
  
  include ViewCustomPages
  include Permissions
  
  def view_entire
    @submenu_title = submenu_title
    
    index
  end
  
  protected
  
  def get_filter
    @viewer.set_project @project
    if !( (@project && @viewer.is_processor?) || @viewer.is_eventgroup_coordinator?(@eg))
      return { :filter => ['confidential'], :default => true }
    end
    return nil
  end

  def submenu_title
    case @type
    when 'app'
      "View Appln"
    when 'ref'
      @ref.reference.text
    end
  end
  
  # overriding from QE
  def get_questionnaire
    if @type == 'app'
      @questionnaire = @appln.form.questionnaire
    elsif @type == 'ref'
      @questionnaire = @ref.questionnaire
    end
    @questionnaire
  end
  
  # overriding from QE
  def questionnaire_instance
    if @type == 'app'
      @appln || params[:appln] # last stmt is a hack since @appln was being lost when set in a template
    else # refs
      @ref
    end
  end
end

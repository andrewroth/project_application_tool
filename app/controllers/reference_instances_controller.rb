require_dependency 'vendor/plugins/reference_engine/app/controllers/reference_instances_controller.rb'
require_dependency 'appln_admin/modules/acceptance_pile_functionality.rb'

class ReferenceInstancesController < InstanceController
  include Permissions
  include AcceptancePileFunctionality

  before_filter :set_profile, :only => BYPASS_ACTIONS
  before_filter :ensure_profile_processor, :only => BYPASS_ACTIONS
  before_filter :clear_user, :except => BYPASS_ACTIONS
  
  skip_before_filter :verify_user, :restrict_students
  skip_before_filter :verify_event_group_chosen
  skip_before_filter :set_event_group
  skip_before_filter :set_filter
  skip_before_filter :get_pages, :only => [ :no_access ]

  protected

  def done_bypass_redirect
    redirect_to :controller => :tools, :action => :reference_resend_or_bypass
  end

  def clear_user
    @user = nil
  end
  
  def set_profile
    @profile = @reference_instance.instance.profile
  end
end 

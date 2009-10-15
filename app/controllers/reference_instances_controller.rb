require_dependency 'vendor/plugins/reference_engine/app/controllers/reference_instances_controller.rb'
require_dependency 'appln_admin/modules/acceptance_pile_functionality.rb'

class ReferenceInstancesController < InstanceController
  include Permissions
  include AcceptancePileFunctionality

  before_filter :set_profile, :only => BYPASS_ACTIONS + [ :submit ]
  before_filter :ensure_profile_processor, :only => BYPASS_ACTIONS
  before_filter :clear_user, :except => BYPASS_ACTIONS

  after_filter :sweep, :only => :submit
  
  skip_before_filter :verify_user, :restrict_students
  skip_before_filter :verify_event_group_chosen
  skip_before_filter :set_event_group
  skip_before_filter :set_filter
  skip_before_filter :get_pages, :only => [ :no_access ]

  cache_sweeper :profiles_sweeper

  protected

  def done_bypass_redirect
    redirect_to :controller => :tools, :action => :reference_resend_or_bypass
  end

  def clear_user
    @viewer = nil
  end
  
  def set_profile
    @profile = @reference_instance.instance.profile
  end

  def sweep
    expire_fragment(%r{your_projects.project_id=#{@profile[:project_id]}&role=.*&section=Submitted})
  end
end 

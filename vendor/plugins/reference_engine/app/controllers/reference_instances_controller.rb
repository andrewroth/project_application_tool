
class ReferenceInstancesController < InstanceController
  BYPASS_ACTIONS = [ :bypass, :bypass_form ]
  prepend_before_filter :get_reference_instance, :except => BYPASS_ACTIONS
  prepend_before_filter :get_reference_instance_from_id, :only => BYPASS_ACTIONS
  
  def bypass
    @reference_instance.bypass!
    done_bypass_redirect
  end

  def no_access
    render :layout => false
  end

  protected

    def get_pages
      unless @questionnaire
        instance_str = begin @instance.id.to_s rescue '' end
        event_group_str = begin @instance.instance.form.event_group.title rescue '' end
        render(:inline => "Error: No questionnaire specified for this reference (ref instance id #{instance_str}, event group \"#{event_group_str}\") - email #{$tech_email_only}.", :layout => true)
        return
      end

      @pages ||= @questionnaire.pages
    end

    def done_bypass_redirect
      throw "done_bypass_redirect this should be overridden"
    end

    def after_submit
      get_reference_instance.submit!
    end

    def questionnaire_instance
      get_reference_instance
    end

    def after_save_form
      @reference_instance ||= get_reference
      @reference_instance.update_attributes(params[:reference])
    end

    def get_reference_instance
      if !@reference_instance.nil?
        return @reference_instance
      end

      id = params[:ref_id] || params[:id]
      # find the actual ref, make sure it's flagged as started
      if params[:key] && id
        @reference_instance = ReferenceInstance.find_by_id_and_access_key(id, params[:key])
        unless @reference_instance
	  r = begin
	    ReferenceInstance.find_by_id id
	  rescue
	    nil
	  end

	  render :inline => if r then "Invalid key to access this reference." else
	     "This reference can't be found.  Most likely this is because the applicant has deleted this reference." 
	     end

          return false
        end
        @reference_instance.start!
      end

      # everything in @pass_params is passed in questionnaire-related ajax requests
      # through hidden fields
      @pass_params = { :ref_id => id, :key => params[:key] }

      @reference_instance
    end

    def clear_user
      @user = nil
    end

    def get_reference_instance_from_id
      @reference_instance = ReferenceInstance.find params[:id]
    end
end

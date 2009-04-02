require_dependency 'vendor/plugins/questionnaire_engine/app/controllers/instance_controller.rb'

class InstanceController
  def delete_reference
    get_current_page

    if @reference
      @instance.attributes[@reference.class.to_s.underscore] = nil
      @instance.save!

      ReferenceMailer.deliver_deleted(@reference) unless @reference.email.to_s.empty?
      @reference.destroy

      # TODO: move this so there is no reference to appln or profile
      @appln.profile.unsubmit! if @appln.submitted?
    end

    flash[:notice] = "Reference deleted.  Please enter a new reference and submit."

    if request.xhr?
      render :inline => flash[:notice]
    else
      redirect_to_default_view
    end
  end

  def send_ref_emails
    # If we haven't yet done so, send reference invitations
    @instance.references.each do |reference|
      send_ref_email(reference) unless reference.email_sent?
    end
  end

  def resend_reference_email
    @reference = @instance.reference_instances.find_by_id params[:ref_id]
    @reference.send_invitation

    flash[:notice] = "Reference request email resent to #{@reference.first_name} #{@reference.last_name} (#{@reference.email})."

    if request.xhr?
      render :inline => flash[:notice]
    else
      redirect_to_default_view
    end
  end
end

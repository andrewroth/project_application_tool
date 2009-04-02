# to edit email templates
# TO DO : make subject line an editable field
class ReferenceEmailsController < ApplicationController   
  before_filter :ensure_eventgroup_coordinator
  before_filter :get_reference_email, :only => [ :update, :edit ]
  
  @@types = { 
              'ref_request'           => 'Ref email: To referrer, requesting a reference',
              'ref_request_confirm'   => 'Ref email: To applicant, confirming that reference request was sent',
              'ref_completed'         => 'Ref email: To referrer, completed reference thank-you',
              'ref_completed_confirm' => 'Ref email: To applicant, confirming completed reference',
              'ref_deleted'           => 'Ref email: To referrer, notifying that reference is no longer needed ',
              'app_completed'         => 'App email: To applicant, that app is submitted and references done',
              'app_unsubmitted'       => 'App email: To applicant, that app is marked incomplete since a ref was deleted',
              'app_withdrawn'         => 'App email: To applicant, that app has been withdrawn',
              'app_submitted'         => 'App email: To applicant, that app submitted and waiting on refs',
              'app_accepted'          => 'App email: To applicant, that app accepted',
              'app_withdrawn_notify'  => 'App email: To projects coordinators, project administrators and project directors, that app withdrawn'
            }
  
  def self.types() @@types end
  
  
  
  def edit
    @type_desc = @@types[@type_key]
    @page_title = "Manage Forms"
  end
  
  def update
    if @reference_email.update_attributes(params[:reference_email])
      flash[:notice] = "Email was successfully updated."
      redirect_to :controller => 'forms'
    else
      flash[:notice] = "There was an error updating the email.  You should notify a system administrator."
      render :action => 'edit'
    end
  end
  
  protected
  
  def ensure_eventgroup_coordinator
    if !@viewer.is_eventgroup_coordinator?(@eg)
      render :inline => "Sorry, you have to be projects coordinator to edit the reference emails."
      return false
    end
  end
  
  def get_reference_email
    if (params[:id])
      @reference_email = @eg.reference_emails.find(params[:id])
    else
      @type_key = params[:email_type]
      @reference_email = @eg.reference_emails.find_by_email_type(@type_key)
    end
  end
  
end

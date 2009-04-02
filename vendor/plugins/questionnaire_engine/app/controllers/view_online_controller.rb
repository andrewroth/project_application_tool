class ViewOnlineController < BaseViewController
  before_filter :set_folder
  
  def save_form
    render :inline => "", :layout => false
  end
  
  def validate_page
    # we're only viewing, so this page is valid, go to the next page
    next_script = "<script>post_form(current_page+1);</script>"
    render :inline => params[:go_next_if_valid] ? next_script : "", :layout => false
  end
  
  # used to make default use processor_online 
  # folder
  def set_folder
    @custom_folder ||= "view_online"
  end

  # by default we'll won't allow confidential questions to be rendered, 
  # since the processor form will derive from this
  def see_confidential
    false
  end
end

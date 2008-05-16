class ReportElementQuestionsController < ReportElementsController
  active_scaffold do |config|
    config.create.columns.exclude :position
    config.list.columns.exclude :position
    config.show.columns.exclude :position
  end

  def list
    redirect_to :controller => :report_elements
  end

  def create
    req = ReportElementQuestion.create params[:report_element_question]
    render :inline => "success: #{req.inspect}" if request.xml_http_request?
  end

  def get_element
    render :layout => false
  end

  def get_pages
    @form = @eg.forms.find params[:form_id]
    @pages = @form.questionnaire.pages
  end

  def get_elements
    @page = Page.find params[:page_id]
  end

  def before_update_save(record)
    super
    logger.info "XYZ: ReportElementQuestionsController::before_update_save #{record.inspect}"
  end

  def before_create_save(record)
    super
    logger.info "XYZ: ReportElementQuestionsController::before_create_save #{record.inspect}"
  end

  protected

end

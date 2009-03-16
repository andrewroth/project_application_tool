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
    if params[:bulk]
      render :inline => params.inspect
      for req in params[:check].keys
        ReportElementQuestion.create :element_id => req, :report_id => params[:report_id]
      end
    else
      req = ReportElementQuestion.create params[:report_element_question]
      render :inline => "success: #{req.inspect}" if request.xml_http_request?
    end
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

  protected

end

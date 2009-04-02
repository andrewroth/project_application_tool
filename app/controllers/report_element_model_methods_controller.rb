class ReportElementModelMethodsController < ReportElementsController
  active_scaffold do |config|
    config.create.columns.exclude :position
    config.list.columns.exclude :position
    config.show.columns.exclude :position
    config.columns = [ :position, :heading, :type, :report_model_method, :element ]
  end

  protected

end

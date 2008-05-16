class ReportElementModelMethod < ReportElement
  belongs_to :report_model_method

  def name
    if heading && !heading.empty?
      heading
    else
      report_model_method ? report_model_method.name : '<no model method chosen>'
    end
  end
end

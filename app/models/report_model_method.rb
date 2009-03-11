class ReportModelMethod < ActiveRecord::Base
  belongs_to :report_model

  def name
    "#{report_model ? report_model.model_s : '?'}.#{method_s}"
  end
end

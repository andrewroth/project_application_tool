class ReportModel < ActiveRecord::Base
  has_many :report_model_methods

  def name
    model_s
  end
end


class ReportModelsController < ApplicationController
  active_scaffold do |config|
    config.columns[:model_s].label = 'Model'
    config.columns[:report_model_methods].label = 'Methods'
  end
end


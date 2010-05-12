class ReportModelsController < ApplicationController
  include Permissions
  before_filter :ensure_projects_coordinator

  active_scaffold do |config|
    config.columns[:model_s].label = 'Model'
    config.columns[:report_model_methods].label = 'Methods'
  end
end


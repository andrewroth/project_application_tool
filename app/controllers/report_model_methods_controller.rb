class ReportModelMethodsController < ApplicationController
  prepend_before_filter :redirect_to_report_models

  active_scaffold do |config|
    config.columns[:method_s].label = 'Method'
    config.columns[:report_model].label = 'Model'
  end

  protected

  def redirect_to_report_models
    redirect_to :controller => 'report_models'
  end
end


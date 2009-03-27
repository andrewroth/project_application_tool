class ReportElementsController < ApplicationController
  active_scaffold do |config|
    config.create.columns.exclude :position
    config.columns = [ :position, :heading, :type, :report_model_method, :element ]
  end

  def toggle_type
    @element_js_id = params[:id].sub('type', 'element')+'_span'
    @method_js_id = params[:id].sub('type', 'report_model_method')+'_span'
  end

  def get_element
    render :layout => false
  end
end

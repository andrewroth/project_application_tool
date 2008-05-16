class ReportElementsController < ApplicationController
  active_scaffold do |config|
    config.create.columns.exclude :position
  end

  def reorder
    moved = []
    params[params[:tbody_id]].delete_if{|id| id == ''}.each_with_index do |id, i|

      begin
        re = ReportElement.find id
      rescue
        session[:new_report_element_position] = {} unless session[:new_report_element_position].class == Hash
	session[:new_report_element_position][id] = i
        next
      end

      re.position = i
      re.save!
      moved << re
    end

    logger.info 'XYZ ' + session[:new_report_element_position].inspect
    logger.info 'XYZ ' + params.inspect
    render :inline => moved.collect { |re| "re[#{re.id}].position=#{re.position}" }.join(", ")
  end

  def toggle_type
    @element_js_id = params[:id].sub('type', 'element')+'_span'
    @method_js_id = params[:id].sub('type', 'report_model_method')+'_span'
  end

  def get_element
    render :layout => false
  end

  def after_create_save(record)
  end

  def before_update_save(record)
    logger.info 'XYZ ReportElementsController::before_update_save'
  end
end

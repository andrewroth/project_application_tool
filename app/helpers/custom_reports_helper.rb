module CustomReportsHelper

  def no_show_existing
    true
  end

  # use the type dropdown for all report element types
  def report_element_model_method_type_form_column(record, input_name) type_form_column(record, input_name) end
  def report_element_question_type_form_column(record, input_name) type_form_column(record, input_name) end
  def report_element_cost_item_type_form_column(record, input_name) type_form_column(record, input_name) end
  def report_element_type_form_column(record, input_name) type_form_column(record, input_name) end

  def type_form_column(record, input_name)
    id = input_name
    toggle_params = { :url => { :controller => :report_elements,
                      :action => :toggle_type,
                      :id => id },
		    :loading => "$('loading').show()",
		    :complete => "$('loading').hide()",
                    :with => "'value='+$('#{input_name}').value" }

    element_js_id = id.sub('type', 'element')+'_span'
    method_js_id = id.sub('type', 'report_model_method')+'_span'
    cost_js_id = id.sub('type', 'cost_item')+'_span'

    select_tag(input_name, options_for_select( [ '',
        ['Question Answer', 'ReportElementQuestion' ],
        ['Person Attribute' ,'ReportElementModelMethod' ],
        ['Cost Item' ,'ReportElementCostItem' ] 
    ] , (record.new_record? ? '' : record.class.name) ), :id => input_name) + observe_field(input_name, toggle_params) + 
      %|
         <script> // set initial visibilities
	 #{if record.class == ReportElement then "$('#{method_js_id}').hide(); $('#{element_js_id}').hide(); $('#{cost_js_id}').hide();"
	 elsif record.class == ReportElementQuestion then "$('#{method_js_id}').hide(); $('#{element_js_id}').show(); $('#{cost_js_id}').hide();";
	 elsif record.class == ReportElementModelMethod then "$('#{method_js_id}').show(); $('#{element_js_id}').hide(); $('#{cost_js_id}').hide();"
	 elsif record.class == ReportElementCostItem then "$('#{method_js_id}').hide(); $('#{element_js_id}').hide(); $('#{cost_js_id}').show();"
	 end
	 }
	 </script>
      |
  end

  # note - these will be set invisible if not the right type by the "set initial visibilities" js above
  def report_element_model_method_element_form_column(record, input_name) element_form_column(record, input_name) end
  def report_element_question_element_form_column(record, input_name) element_form_column(record, input_name) end
  def report_element_cost_item_element_form_column(record, input_name) element_form_column(record, input_name) end
  def report_element_element_form_column(record, input_name) element_form_column(record, input_name) end

  def element_form_column(record, input_name)
    visible = record.class == ReportElementQuestion
    return "<span id='#{input_name}_span', style='#{visible ? '' : 'display:none'}'>" + 
      textfield_popup_helper(:record => record, 
       :method => :element_id, 
       :id => input_name, 
       :controller => 'report_element_questions',
       :link_text => image_tag("new_window.gif", :class => 'new_window_img')) +
      observe_field(input_name, :url => { :controller => 'report_element_questions', 
                                          :action => :update_element_text,
					  :js_id => input_name },
				:frequency => 0.5,
		                :loading => "$('loading').show()",
		                :complete => "$('loading').hide()",
                                :with => "'element_id='+$F('#{input_name}')"
	    ) + 
      "<span id='#{input_name}_text'>" +
         (h record.element.text_summary(:include_type => true) if record.element).to_s + 
      "</span>" +
     "</span>"
  end

  # note - these will be set invisible if not the right type by the "set initial visibilities" js above
  def report_element_model_method_report_model_method_form_column(record, input_name) report_model_method_form_column(record, input_name) end
  def report_element_question_report_model_method_form_column(record, input_name) report_model_method_form_column(record, input_name) end
  def report_element_cost_item_report_model_method_form_column(record, input_name) report_model_method_form_column(record, input_name) end
  def report_element_report_model_method_form_column(record, input_name) report_model_method_form_column(record, input_name) end

  def report_model_method_form_column(record, input_name)
    "<span id='#{input_name}_span'>" + 
      collection_select(:record, :report_model_method_id, ReportModelMethod.find(:all, :include => :report_model).delete_if { 
           |mm| mm.report_model.nil?  # get rid of the ones that start with '?' ie. they don't have a valid model (should we delete them?)
	 }.sort { 
	   |a,b| a.name <=> b.name # issue 1427, as requested
	 }, :id, :name, 
        options ={:prompt => "- select -"}, :id => input_name, :name => input_name) + 
    "</span>"
  end
 
  # note - these will be set invisible if not the right type by the "set initial visibilities" js above
  def report_element_model_method_cost_item_form_column(record, input_name) report_cost_item_form_column(record, input_name) end
  def report_element_question_cost_item_form_column(record, input_name) report_cost_item_form_column(record, input_name) end
  def report_element_cost_item_cost_item_form_column(record, input_name) report_cost_item_form_column(record, input_name) end
  def report_element_cost_item_form_column(record, input_name) report_cost_item_form_column(record, input_name) end

  def report_cost_item_form_column(record, input_name)
    "<span id='#{input_name}_span'>" + 
      collection_select(:record, :cost_item_id, @eg.cost_items.find_all { 
           |ci| (ci.is_a?(YearCostItem) || ci.is_a?(ProjectCostItem)) && ci.optional 
	 }.sort { 
	   |a,b| a.description <=> b.description # issue 1427, as requested
	 }, :id, :description, 
        options ={:prompt => "- select -"}, :id => input_name, :name => input_name) + 
    "</span>"
  end

  include ActiveScaffoldSortableSubforms
  active_scaffold_sortable_subform :report_element_model_method => :position, 
                                   :report_element_question => :position,
                                   :report_element_cost_item => :position,
                                   :report_element => :position

  protected

  def textfield_popup_helper(params)
    record = params[:record]
    input_name = params[:id]
    link_name = params[:link] || 'choose'
    link_text = params[:link_text] || link_name + ' ...'
    controller = params[:controller]
    method_sym = params[:method]

      text_field(:record, method_sym, :id => input_name, :name => input_name, :class => 'id_textfield') + 
      link_to(link_text, 
       { :controller => controller, :action => 'get_element', :js_id => input_name, :report_id => record.report_id }, 
       { :popup => ['new_window', 'height=600,width=600,resizable=1,scrollbars=1'], :class => 'element_new_window' }
      )
  end
end


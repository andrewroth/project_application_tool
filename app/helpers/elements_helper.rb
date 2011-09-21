module ElementsHelper
  include ElementsRouteMaps
  include PagesRouteMaps
  include QuestionnaireRouteMaps
  include ReadonlyHelper

  INITIALLY_REQUIRED = {
    :appln_person => { :first_name => true, :last_name => true, :gender => true, :email => true},
    :emerg => {}
  }

  def custom_element_text_field(txt, m, c)
    custom_element_item(txt, m, c) do |m, c, classes| 
      text_field m, c, :class => classes
    end
  end

  MAP_ID = { 
#    :person_local_province_id => :local_province,
#    :person_local_country_id => :local_country,
#    :person_province_id => :permanent_province,
#    :person_country_id => :permanent_country,
#    :gender_id => :gender,
#    :health_province_id => :health_province_longDesc,
#    :title_id => :title
  }

  def custom_element_visible(name, method = "header")
    return true if @readonly
    return true if custom_element_edit_mode || custom_element_create_mode
    return true if @element.nil?
    !@element.custom_element_hidden_sections.find_by_name(name, method).present?
  end

  def custom_element_item(txt, m, c)
    if (!@readonly && @element.nil?) || 
         (!@readonly && !custom_element_edit_mode && !custom_element_create_mode && 
          @element.custom_element_hidden_sections.detect{ |s| s.name == m.to_s && s.attribute == c.to_s })
      return ""
    end

    if @readonly
      if MAP_ID[c] then c = MAP_ID[c] end

      return %|
<span class="readonly_question_text">#{txt}</span><br />
<span class="blue">#{instance_variable_get("@#{m}").send(c)}</span><br />
|
    end

    reqd_section = @element && 
                   @element.custom_element_required_sections.detect{ |s| s.name == m.to_s && s.attribute == c.to_s }

    %|
<P>
 #{error_wrap(@current_page, "#{m}_#{c}", %|
   #{custom_element_item_header(m,c)}
   #{txt} #{yield m, c, if reqd_section then 'required' else '' end}
   #{custom_element_item_footer(m,c)}
 |)}
</P>
   |
  end

  def custom_element_item_header(m,c)
  end

  def custom_element_item_footer(m,c)
    html = ""
    if custom_element_create_mode
      html += check_box_tag("required_#{m}_#{c}", 'required', INITIALLY_REQUIRED[m][c], :name => "required[#{m}][#{c}]") + " required? "
      html += check_box_tag("hidden_#{m}_#{c}", 'hidden', false, :name => "hidden[#{m}][#{c}]") + " hidden?"
    elsif custom_element_edit_mode
      unless c == "header" # can't require headers
        # required
        id = "required_#{m}_#{c}"
        checked = @element.custom_element_required_sections.detect{ |cers| cers.name == m.to_s && cers.attribute == c.to_s } != nil
        html += check_box_tag(id, 'required', checked, :name => "required[#{m}][#{c}]") + " required?" + 
          observe_field(id, :url => { :controller => :custom_element_required_sections, :action => :set,
                        :element_id => @element.id, :name => m, :attribute => c },
                        :with => "'checked='+$('#{id}').checked",
                        :loading => "$('saving').show();", 
                        :success => "$('saving').hide();")
      end
      # hidden
      id = "hidden_#{m}_#{c}"
      hidden = @element.custom_element_hidden_sections.detect{ |cers| cers.name == m.to_s && cers.attribute == c.to_s } != nil
      html += check_box_tag(id, 'hidden', hidden, :name => "hidden[#{m}][#{c}]") + " hidden?" + 
        observe_field(id, :url => { :controller => :custom_element_hidden_sections, :action => :set,
                      :element_id => @element.id, :name => m, :attribute => c },
                      :with => "'hidden='+$('#{id}').checked",
                      :loading => "$('saving').show();", 
                      :success => "$('saving').hide();")
    end
    return html
  end

  def custom_element_render_mode
    !custom_element_edit_mode && custom_element_create_mode
  end

  def custom_element_edit_mode
    %w(edit).include? params[:action]
  end

  def custom_element_create_mode
    %w(show_element_form).include? params[:action]
  end
end


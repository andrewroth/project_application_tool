module ElementsHelper
  include ElementsRouteMaps
  include PagesRouteMaps
  include QuestionnaireRouteMaps

  INITIALLY_REQUIRED = {
    :appln_person => { :person_fname => true, :person_lname => true, :gender_id => true, :person_email => true},
    :emerg => {}
  }

  def custom_element_text_field(txt, m, c)
    custom_element_item(txt, m, c) do |m, c, classes| 
      text_field m, c, :class => classes
    end
  end

  def custom_element_item(txt, m, c)
    %|
<P>
 #{error_wrap(@current_page, "#{m}_#{c}", %|
   #{custom_element_item_header(m,c)}
   #{txt} #{yield m, c, ''}
   #{custom_element_item_footer(m,c)}
 |)}
</P>
   |
  end

  def custom_element_item_header(m,c)
  end

  def custom_element_item_footer(m,c)
    if custom_element_create_mode
      check_box_tag("required_#{m}_#{c}", 'required', INITIALLY_REQUIRED[m][c], :name => "required[#{m}][#{c}]") + " required?"
    elsif custom_element_edit_mode
      id = "required_#{m}_#{c}"
      checked = @element.custom_element_required_sections.detect{ |cers| cers.name == m.to_s && cers.attribute == c.to_s } != nil
      check_box_tag(id, 'required', checked, :name => "required[#{m}][#{c}]") + " required?" + 
      observe_field(id, :url => { :controller => :custom_element_required_sections, :action => :set,
                                   :element_id => @element.id, :name => m, :attribute => c },
                         :with => "'checked='+$('#{id}').checked",
                         :loading => "$('saving').show();", 
                         :success => "$('saving').hide();")
    end
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


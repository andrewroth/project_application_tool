# Methods added to this helper will be available to all templates in the application.
require 'questionnaire_engine'

module ApplicationHelper
  include QE

  def error_wrap(page, element, body)
    if page && page.invalid_elements && page.invalid_elements.include?(element)
      return "<div class=\"fieldWithErrors\">#{body}</div>"
    else
      return body
    end
  end
  
  def boolean_select(object, method, options = {}, html_options = {})
    choices = [['No',false],['Yes',true]]
    select(object, method, choices, options, html_options)
  end
  
  def can_not_edit?(element)
    return questionnaire_instance.frozen?
  end

  def is_true(val)
    [1,'1',true,'true'].include?(val)
  end
  
  # returns the text of a select/option, given a value and a collection of options
  def option_text(element_value, map)
      pair = map.find { |n, v| v == element_value }
      return pair[0] unless pair.nil?
      
      element_value
  end
  
end

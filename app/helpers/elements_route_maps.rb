# map old QE route methods to rails 2 route methods
module ElementsRouteMaps
  def elements_url(q,p)
    questionnaire_page_elements_url(q,p)
  end
  def new_element_url(q,p)
    new_questionnaire_page_element_url(q,p)
  end
  def edit_element_url(q,p,e)
    edit_questionnaire_page_element_url(q,p,e)
  end
  def set_element_max_length_element_url(q,p,e)
    set_element_max_length_questionnaire_page_element_url(q,p,e)
  end
  def copy_element_url(q,p,e)
    copy_questionnaire_page_element_url(q,p,e)
  end
  def reorder_element_url(q,p,e)
    reorder_questionnaire_page_element_url(q,p,e)
  end
  def element_url(q,p,e)
    questionnaire_page_element_url(q,p,e)
  end
  def change_type_element_url(q,p,e)
    change_type_questionnaire_page_element_url(q,p,e)
  end
  def show_element_form_elements_url(q,p)
    show_element_form_questionnaire_page_elements_url(q,p)
  end
  def set_element_text_element_url(q,p,e)
    set_element_text_questionnaire_page_element_url(q,p,e)
  end
end


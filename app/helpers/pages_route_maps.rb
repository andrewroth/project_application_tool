# to map the questionnaire engines old route methods to new route methods
module PagesRouteMaps
  def set_page_title_page_url(q,p)
    set_page_title_questionnaire_page_url(q,p)
  end

  def edit_page_url(q,p)
    edit_questionnaire_page_url(q,p)
  end

  def copy_page_url(q,p)
    copy_questionnaire_page_url(q,p)
  end

  def page_url(q,p)
    questionnaire_page_url(q,p)
  end

  def export_page_url(q,p)
    export_questionnaire_page_url(q,p)
  end

  def edit_page_url(q,p)
    edit_questionnaire_page_url(q,p)
  end

  def reorder_page_url(q,p)
    reorder_questionnaire_page_url(q,p)
  end
end


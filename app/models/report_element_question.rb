class ReportElementQuestion < ReportElement
  #belongs_to :element_id

  def name
    if heading && !heading.empty?
      heading
    elsif element
      element.text_summary(:include_type => true, :length => 20)
    else
      '<no element chosen>'
    end
  end
end

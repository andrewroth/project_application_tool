class ReportElementQuestion < ReportElement
  def name
    if heading && !heading.empty?
      heading
    elsif cost_item
      cost_item.description
    else
      '<no cost item chosen>'
    end
  end
end

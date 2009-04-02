class Group < Element
  def validate!(page, instance)
    if self.is_required?
      #check to see if at least one question element in this group has an answer
      unless has_answer?(instance)
        page.errors.add_to_base("\"#{text}\" requires an answer") 
        page.add_invalid_element(self)
      end
    else
      elements.each do |element|
        element.validate!(page, instance)
      end
    end
  end
  
  def has_required?
    # elements refers to child elements
    elements.each do |element|
      return true if element.is_required?
    end
    return false
  end
  
  def has_answer?(instance)
    elements.each do |element|
      return true if element.has_answer?(instance)
    end
    return false
  end
    
  def save_answer(person, params, answers)
    for question in elements
      question.save_answer(person, params, answers)
    end
  end
end

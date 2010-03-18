class Multicheckbox < Question
  has_many :checkboxfields, :foreign_key => :parent_id, :order => :position
  
  def has_answer?(instance)
    checkboxfields.each do |checkbox|
      return true if checkbox.has_answer?(instance)
    end
    return false
  end
  
  def get_verbose_answer(instance_id, params)
    checkboxfields.collect { |checkbox|
      checkbox.text if %w(true 1).include?(checkbox.get_answer(instance_id, params))
    }.compact.join(', ')
  end

  def save_answer(instance, params, answers)
    for checkbox in checkboxfields
      checkbox.save_answer(instance, params, answers)
    end
  end
end

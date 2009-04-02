class Checkboxfield < Question
  def get_verbose_answer(instance, params)
    a = get_answer(instance, params)
    if [ 1, '1', 'true', true ].include? a
      'Y'
    else
      ''
    end
  end

  def before_save
    self.is_required = false
    return true
  end
  
  def is_empty?(answer)
    ['0','false',''].include?(answer.to_s)
  end
end

class YesNo < Question
  def get_verbose_answer(instance, params)
    a = get_answer(instance, params)
    if a == '0'
      'No'
    elsif a == '1'
      'Yes'
    else
      ''
    end
  end
end

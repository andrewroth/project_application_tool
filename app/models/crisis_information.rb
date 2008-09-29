class CrisisInformation < Element

  def text()
    "Crisis Information Form here"
  end

  def save_answer(instance, params, answers)
  end

  def validate!(page, instance)
      #page.errors.add_to_base("All reference fields must be completed ")
      #page.add_invalid_element(self)
  end
end


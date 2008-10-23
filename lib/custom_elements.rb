module CustomElements
  def custom_answer(instance)
    if question_table == "person" && question_column.to_s == "email"
      instance.viewer.email
    end
  end
end

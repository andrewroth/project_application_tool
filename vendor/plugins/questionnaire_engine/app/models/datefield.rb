class Datefield < Question
  def validate!(page, instance)
    # add an error if this is not in the required format
    if (get_answer(instance) != "") && !(get_answer(instance) =~ /^\d\d?\/\d\d?\/\d\d\d\d$/)
      page.errors.add_to_base("\"#{text}\" should be in the format MM/DD/YYYY")
      page.add_invalid_element(self)
    end
  end
end

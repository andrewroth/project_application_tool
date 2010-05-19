Factory.define :form_1, :class => Form, :singleton => true do |f|
  f.id 1
  f.name "Application Form"
  f.after_create { |form|
    form.questionnaire = Factory(:questionnaire, :title => form.name)
    form.save!
  }
end

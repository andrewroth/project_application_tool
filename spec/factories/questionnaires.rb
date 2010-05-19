Factory.define :questionnaire, :class => FormQuestionnaire do |q|
  q.title "Application Form"
  q.after_create { |q|
    Factory(:questionnaire_page, :questionnaire => q, :page => Factory(:page))
    Factory(:questionnaire_page, :questionnaire => q, :page => Factory(:page))
    Factory(:questionnaire_page, :questionnaire => q, :page => Factory(:page))
    Factory(:questionnaire_page, :questionnaire => q, :page => Factory(:page))
  }
end

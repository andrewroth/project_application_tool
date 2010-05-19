require File.dirname(__FILE__) + '/../spec_helper'
uses_factories

describe Appln do
  before(:each) do
    Form.delete_all
    Questionnaire.delete_all
    Appln.delete_all
    @form_1 = Factory(:form_1)
    @q_1 = @form_1.questionnaire
    Factory(:questionnaire_page, :questionnaire => @q_1, :page => Factory(:page))
    @appln_1 = Factory(:appln_1)
    @appln_2 = Factory(:appln_2)
  end

  it "should throw an error when the forms don't match" do
    @appln_2.form_id = nil
    got_error = false
    begin
      @appln_2.copy_answers(@appln_1)
    rescue
      got_error = true
    end
    got_error.should == true
  end

  it "should copy all answers and reference answers successfully" do
    @answers = {}
    i = 0
    @appln_1.form.questionnaire.pages.each do |page|
      page.elements.each do |element|
        next unless element.is_a?(Question)
        ans = "a#{i}"
        Answer.create! :question_id => element.id, :answer => ans, :instance_id => @appln_1.id
        @answers[element.id] = ans
        i += 1
      end
    end
    @appln_2.copy_answers(@appln_1)
    @answers.each_pair do |k,v|
      a = Answer.find_by_question_id_and_answer_and_instance_id k, v, @appln_2.id
      a.should_not be_nil
    end
  end
end

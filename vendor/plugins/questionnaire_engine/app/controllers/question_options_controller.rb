class QuestionOptionsController < ApplicationController
  before_filter :find_question_option, :except => [:create, :reorder]
  in_place_edit_for :question_option, :option
  in_place_edit_for :question_option, :value
  
  def create
    create_with_id(params[:question_id])
  end
  
  def create_with_id(id)
    @question_option = QuestionOption.new
    @question_option.option = "New Option"
    @question_option.value = "New Value"
    @question_option.question_id = id
    @question_option.save!
    @question_option
  end
  
  def destroy
    if request.delete?
      @question_option.destroy
    end
  end
  
  def reorder
    Element.find(params[:element_id]).question_options.each do |question_option|
      question_option.position = params['question_options'].index(question_option.id.to_s)
      question_option.save
    end
    render :nothing => true
  end

  protected
    def find_question_option
      @question_option = QuestionOption.find(params[:id])
    end
end

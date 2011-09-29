class Question < Element
  has_many  :answers, :foreign_key => "question_id"
  
  before_create :set_defaults
  
  def set_defaults
    self.is_required ||= true
    self.question_table ||= 'answers'  
  end

  def template
    "question"
  end
  
  def column
    if (question_table == "answers")
      return id
    else 
      #Set the column variable to the question ID
      return question_column
    end
  end
  def css_class
    if is_required?
      "required"
    else 
      ""
    end
  end 
  
  # This method saves answers that are stored in the generic "answers" table.
  # Answers stored in custom objects must be handled seperately
  def save_answer(instance, params, answers)
    if question_table == "answers"
      # Make sure there is an answer on the page 
      unless params[:answers].nil? || params[:answers][id.to_s].nil?
        @answer = answers[id]
        unless @answer.nil?
          if (@answer.answer != params[:answers][id.to_s])
            @answer.answer = params[:answers][id.to_s]
            @answer.save!
          end
        else
          # Double check to make sure this question hasn't been answered
          begin
            try_to_save(instance, params)
          # We think there might be a race condition causing a double-insert
          # To prevent this, there is a unique index on the table that should
          # cause an error to be thrown. We will catch that error, and try again.
          rescue ActiveRecord::StatementInvalid
            try_to_save(instance, params)
          end
        end
        answers[id] = @answer #update the hash in case it is used again
      end 
    end
  end
  
  protected  
    def try_to_save(instance, params)
      @answer = Answer.find_by_instance_id_and_question_id(instance.id, id) ||
                      Answer.new(:instance_id => instance.id, :question_id => id)
      return if @answer.answer == params[:answers][id.to_s]
      @answer.answer = params[:answers][id.to_s]
      @answer.save!
    end
end

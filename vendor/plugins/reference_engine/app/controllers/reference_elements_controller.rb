class ReferenceElementsController < ElementsController
  def set_questionnaire_id
    Reference.find(params[:id]).questionnaire_id = params[:value]
    render :inline => 'success'
  end
end


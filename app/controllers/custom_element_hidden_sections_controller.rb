class CustomElementHiddenSectionsController < ApplicationController
  def set
    e = Element.find params[:element_id]
    cehs = e.custom_element_hidden_sections.find_by_name_and_attribute params[:name], params[:attribute]
    checked = params[:hidden] == 'true'

    if checked && !cehs
      e.custom_element_hidden_sections.create :name => params[:name], :attribute => params[:attribute]
    elsif !checked && cehs
      cehs.destroy
    end

    render :inline => 'success'
  end
end

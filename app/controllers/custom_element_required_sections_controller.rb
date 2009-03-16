class CustomElementRequiredSectionsController < ApplicationController
  def set
    e = Element.find params[:element_id]
    cers = e.custom_element_required_sections.find_by_name_and_attribute params[:name], params[:attribute]
    checked = params[:checked] == 'true'

    if checked && !cers
      e.custom_element_required_sections.create :name => params[:name], :attribute => params[:attribute]
    elsif !checked && cers
      cers.destroy
    end

    render :inline => 'success'
  end
end

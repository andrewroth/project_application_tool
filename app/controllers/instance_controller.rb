# I'm not sure if this file is being processed!
# .. I've tried adding code that will obviously crash and it's not being compliled
#
# my extensions to the QE
require 'questionnaire_engine/completion_indicator.rb'

class InstanceController < BaseViewController
  include CompletionIndicator
  include BulkPrinting
  
  before_filter :set_view_pass_param, :only => [ :submit ] # for redirect, :init_form_from_param will 
                                                           # be hit on subsequent direct to display_page
  before_filter :set_form_to_view, :only => [ :submit ] # incase there are errors
  before_filter :init_form_from_param, :only => [ :get_page ]
  before_filter :set_person_and_emerg
  
  def set_form_to_view() @form = 'view' end
  def set_view_pass_param() @pass_params[:form] = "view" end
  def init_form_from_param() @form ||= params[:form] end

  # enables the initial default values from the db on the custom
  # person / emerg elements
  def set_person_and_emerg()
    begin
      @person = @instance.viewer.person
      @emerg = @person.emerg
      #throw 'P: ' + @person.inspect
    rescue Exception
    end
  end
end

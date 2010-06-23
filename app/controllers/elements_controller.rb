require_dependency 'vendor/plugins/questionnaire_engine/app/controllers/elements_controller'
require_dependency 'vendor/plugins/reference_engine/app/controllers/elements_controller.rb'

class ElementsController < ApplicationController
  TYPES_FOR_SELECT << ['Personal Information', 'PersonalInformation'] << 
                      ['Crisis Information','CrisisInformation'] <<
                      ['Campus Information','CampusInformation']
end


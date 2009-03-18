require_dependency 'vendor/plugins/questionnaire_engine/app/controllers/elements_controller'

class ElementsController < ApplicationController
  TYPES_FOR_SELECT << ['Personal Information', 'PersonalInformation'] << 
                      ['Crisis Information','CrisisInformation'] <<
                      ['Campus Information','CampusInformation']
end


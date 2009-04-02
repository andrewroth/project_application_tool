# custom routes for application
ActionController::Routing::Routes.draw do |map|
  map.resources :reference_elements,
    :path_prefix => '/admin/questionnaires/:questionnaire_id/pages/:page_id/reference_elements/:id',
    :member =>     { :set_questionnaire_id => :post,
  }

  # DC - not sure if this should be commented or not. Uncommenting to try to fix referencing bypasses
  map.resources :reference_instances, 
    :member => { :bypass_form => :get, :bypass => :post }, 
    :collection => { :no_access => :get }

  map.resources :references
end

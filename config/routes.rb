ActionController::Routing::Routes.draw do |map|
  map.resources :eventgroup_coordinators, :member => { :list => :get, :new => :get, :create => :post }

  map.resources :projects_coordinators

  map.resources :custom_element_required_sections

  map.resources :assignments

  map.resources :notification_acknowledgments
  map.resources :notifications

  map.resources :reason_for_withdrawals

  map.resources :prep_items
  map.resources :profile_prep_items

  QUESTIONNAIRE_ACTIONS = { :get_page => [ :get, :post ], :validate_page => :post }

  map.resources :profiles_viewer, :member => { :entire => :get, :summary => :get, 
    :delete_reference => :get, :submit => :post }.merge(QUESTIONNAIRE_ACTIONS)
  map.resources :references_viewer, QUESTIONNAIRE_ACTIONS
  map.resources :processor_viewer, QUESTIONNAIRE_ACTIONS

  map.resources :projects, :member => { :bulk_summary_forms => :get, :bulk_processor_forms => :get }

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  #map.resources :forms, :collection => { :clone_form => :post }

  # questionnaire engine routes
  
  #load 'questionnaire_routes.rb'

  map.resources :custom_element_required_sections

  map.resources :assignments

  map.resources :notification_acknowledgments

  map.resources :notifications

  map.resources :airports

  map.resources :countries

  map.resources :reason_for_withdrawals

  map.resources :event_groups, :collection => [ :scope ], :member => [ :set_as_scope ]

  #  @qe_routes.call(map)
  #end

  map.from_plugin :questionnaire_engine
  
  map.connect 'javascripts/questionnaire2.js', :controller => "main", :action => "questionnaire"
  
  map.from_plugin :reference_engine
  #map.from_plugin :'selenium-on-rails'
  
  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "main"
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end

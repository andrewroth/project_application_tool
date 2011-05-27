require_dependency 'permissions'

class CountriesController < ApplicationController
  include Permissions

  active_scaffold unless RAILS_ENV == "test"

  before_filter :ensure_eventgroup_coordinator
end

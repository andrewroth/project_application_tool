require_dependency 'permissions'

class CountriesController < ApplicationController
  include Permissions

  active_scaffold

  before_filter :ensure_eventgroup_coordinator
end

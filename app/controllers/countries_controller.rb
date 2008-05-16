require 'permission'

class CountriesController < ApplicationController
  include Permissions

  active_scaffold

  before_filter :ensure_projects_coordinator
end

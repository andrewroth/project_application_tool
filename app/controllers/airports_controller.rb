require 'permission'

class AirportsController < ApplicationController
  include Permissions

  active_scaffold

  before_filter :ensure_eventgroup_coordinator
end

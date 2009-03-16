class NotificationsController < ApplicationController
  include Permissions

  before_filter :ensure_eventgroup_coordinator

  active_scaffold
end

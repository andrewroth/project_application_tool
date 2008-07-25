class NotificationsController < ApplicationController
  include Permissions

  before_filter :ensure_projects_coordinator

  active_scaffold
end

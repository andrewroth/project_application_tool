class TodosController < ApplicationController
  include Permissions

  before_filter :set_menu_titles, :ensure_able_to_edit, :can_see_todos

  def index
    if is_any_project_director || is_any_project_administrator
      flash[:warning] = "Please be careful to only add/change/delete todos that are for the projects you are assigned to."
    end
  end

  protected

  def set_menu_titles() @page_title = 'Manage Projects'; @submenu_title = 'todos' end

  def is_able_to_edit
    is_eventgroup_coordinator || is_any_project_director || is_any_project_administrator
  end

  def can_see_todos
    @can_see_todos = is_eventgroup_coordinator_or_project_admin_or_director
  end
end

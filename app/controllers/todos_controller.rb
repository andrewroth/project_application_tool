class TodosController < ApplicationController
  before_filter :set_menu_titles

  protected

  def set_menu_titles() @page_title = 'Manage Projects'; @submenu_title = 'todos' end
end


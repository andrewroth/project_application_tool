class AddEndDateToAccesses < ActiveRecord::Migration
  def self.up
    add_column :projects_coordinators, :end_date, :date
    add_column :eventgroup_coordinators, :end_date, :date
    Viewer.roles_plural.each do |table|
      add_column table, :end_date, :date
    end
  end

  def self.down
    remove_column :projects_coordinators, :end_date, :date
    remove_column :eventgroup_coordinators, :end_date, :date
    Viewer.roles_plural.each do |table|
      remove_column table, :end_date, :date
    end
  end
end

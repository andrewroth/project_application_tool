class AddIndependantAndDependantToCustomReports < ActiveRecord::Migration
  def self.up
    add_column :custom_report_columns, :dependencies,  :integer
  end

  def self.down
    remove_column :custom_report_columns, :dependencies
  end
end

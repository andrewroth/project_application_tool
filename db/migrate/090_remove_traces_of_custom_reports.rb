class RemoveTracesOfCustomReports < ActiveRecord::Migration
  def self.up
    drop_table :custom_report_columns
  end

  def self.down
  end
end

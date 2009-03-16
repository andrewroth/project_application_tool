class RemoveTracesOfCustomReports < ActiveRecord::Migration
  def self.up
    drop_table :custom_report_columns
    drop_table :data_maps
  end

  def self.down
  end
end
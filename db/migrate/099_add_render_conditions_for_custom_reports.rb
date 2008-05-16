class AddRenderConditionsForCustomReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :include_accepted, :boolean, :default => true
    add_column :reports, :include_applying, :boolean, :default => false
    add_column :reports, :include_staff, :boolean, :default => false
  end

  def self.down
    remove_column :reports, :include_accepted
    remove_column :reports, :include_applying
    remove_column :reports, :include_staff
  end
end

class AddAllowsMultipleApplicationsWithSameFormToEventGroup < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :allows_multiple_applications_with_same_form, :boolean
  end

  def self.down
    remove_column :event_groups, :allows_multiple_applications_with_same_form, :boolean
  end
end

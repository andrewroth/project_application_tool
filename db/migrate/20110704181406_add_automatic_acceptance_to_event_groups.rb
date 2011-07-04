class AddAutomaticAcceptanceToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :automatic_acceptance, :boolean, :default => true
  end

  def self.down
    remove_column :event_groups, :automatic_acceptance
  end
end

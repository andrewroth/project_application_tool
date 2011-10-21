class MakeAutomaticAcceptanceDefaultFalse < ActiveRecord::Migration
  def self.up
    change_column :event_groups, :automatic_acceptance, :boolean, :default => false
  end

  def self.down
    change_column :event_groups, :automatic_acceptance, :boolean, :default => true
  end
end

class AddOutgoingEmailToEventGroup < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :outgoing_email, :string
  end

  def self.down
    delete_column :event_groups, :outgoing_email
  end
end

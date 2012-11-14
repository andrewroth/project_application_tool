class AddRecordOfFundsAttachmentIdToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :record_of_funds_attachment_id, :integer
  end

  def self.down
    remove_column :event_groups, :record_of_funds_attachment_id
  end
end

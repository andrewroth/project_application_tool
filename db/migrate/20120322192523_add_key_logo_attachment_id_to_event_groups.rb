class AddKeyLogoAttachmentIdToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :key_logo_attachment_id, :integer
  end

  def self.down
    remove_column :event_groups, :key_logo_attachment_id
  end
end

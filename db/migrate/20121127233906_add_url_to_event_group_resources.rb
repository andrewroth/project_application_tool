class AddUrlToEventGroupResources < ActiveRecord::Migration
  def self.up
    add_column :event_group_resources, :url, :string
  end

  def self.down
    remove_column :event_group_resources, :url
  end
end

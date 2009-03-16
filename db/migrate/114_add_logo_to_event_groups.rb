class AddLogoToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :content_type, :string
    add_column :event_groups, :filename, :string    
    add_column :event_groups, :thumbnail, :string 
    add_column :event_groups, :size, :integer
    add_column :event_groups, :width, :integer
    add_column :event_groups, :height, :integer
  end

  def self.down
    remove_column :event_groups, :content_type
    remove_column :event_groups, :filename
    remove_column :event_groups, :thumbnail
    remove_column :event_groups, :size
    remove_column :event_groups, :width
    remove_column :event_groups, :height
  end
end

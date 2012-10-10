class AddPaperworkToPrepItems < ActiveRecord::Migration
  def self.up
    add_column :prep_items, :paperwork, :boolean, :default => false
  end

  def self.down
    remove_column :prep_items, :paperwork
  end
end

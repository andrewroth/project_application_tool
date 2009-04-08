class AddDeadlineOptionalToPrepItems < ActiveRecord::Migration
  def self.up
    begin
      add_column :prep_items, :deadline_optional, :boolean, :default => false
    rescue
    end
  end

  def self.down
    begin
      remove_column :prep_items, :deadline_optional
    rescue
    end
  end
end

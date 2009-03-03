class RemoveProjectIdFromPrepItems < ActiveRecord::Migration
  def self.up
    remove_column :prep_items, :project_id
  end

  def self.down
     add_column :prep_items, :project_id, :integer, :options => "CONSTRAINT fk_prep_item_projects REFERENCES projects(id)"
  end
end

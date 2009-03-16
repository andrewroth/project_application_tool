class CreatePrepItems < ActiveRecord::Migration
  def self.up
    create_table :prep_items do |t|
      t.string :title
      t.text :description
      t.date :deadline
      t.integer :event_group_id, :options => "CONSTRAINT fk_prep_item_event_groups REFERENCES event_groups(id)"
      t.integer :project_id, :options => "CONSTRAINT fk_prep_item_projects REFERENCES projects(id)"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :prep_items
  end
end

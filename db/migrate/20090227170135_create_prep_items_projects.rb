class CreatePrepItemsProjects < ActiveRecord::Migration
  def self.up
    create_table "prep_items_projects", :id =>false do |t|
    t.column "prep_item_id", :integer, :null =>false
    t.column "project_id", :integer, :null =>false
    end
  end

  def self.down
    drop_table "prep_items_projects"
  end
end

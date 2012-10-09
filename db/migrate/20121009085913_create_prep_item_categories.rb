class CreatePrepItemCategories < ActiveRecord::Migration
  def self.up
    create_table :prep_item_categories do |t|
      t.string :title
      t.integer :event_group_id

      t.timestamps
    end
    add_column :prep_items, :prep_item_category_id, :integer
  end

  def self.down
    drop_table :prep_item_categories
    remove_column :prep_items, :prep_item_category_id
  end
end

class CreateProfilePrepItems < ActiveRecord::Migration
  def self.up
    create_table :profile_prep_items do |t|
      t.integer :profile_id
      t.integer :prep_item_id
      t.boolean :submitted, :default => false
      t.boolean :recieved, :default => false
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_prep_items
  end
end

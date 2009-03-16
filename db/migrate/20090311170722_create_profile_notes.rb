class CreateProfileNotes < ActiveRecord::Migration
  def self.up
    create_table :profile_notes do |t|
      t.text :content
      t.integer :profile_id
      t.integer :creator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_notes
  end
end

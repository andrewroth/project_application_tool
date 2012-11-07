class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.integer :resource_id
      t.string :filename
      t.string :content_type
      t.integer :size

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end

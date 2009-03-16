class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.column :tagee_type, :int
      t.column :tagee_id, :int
      t.column :tag_id, :int
    end
  end
  
  def self.down
    drop_table :taggings
  end
end

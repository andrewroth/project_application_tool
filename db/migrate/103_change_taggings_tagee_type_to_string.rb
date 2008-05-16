class ChangeTaggingsTageeTypeToString < ActiveRecord::Migration
  def self.up
    change_column :taggings, :tagee_type, :string 
  end

  def self.down
    change_column :taggings, :tagee_type, :int 
  end
end

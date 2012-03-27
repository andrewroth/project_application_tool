class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.integer :thumbnail
      t.integer :size

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end

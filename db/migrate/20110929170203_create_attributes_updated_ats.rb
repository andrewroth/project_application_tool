class CreateAttributesUpdatedAts < ActiveRecord::Migration
  def self.up
    create_table :attributes_updated_ats do |t|
      t.integer :person_id
      t.string :table_name
      t.string :attr_name

      t.timestamps
    end
    add_index :attributes_updated_ats, [ :person_id, :table_name, :attr_name ]
  end

  def self.down
    drop_table :attributes_updated_ats
  end
end

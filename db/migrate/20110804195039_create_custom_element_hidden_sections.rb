class CreateCustomElementHiddenSections < ActiveRecord::Migration
  def self.up
    create_table :custom_element_hidden_sections do |t|
      t.integer :element_id
      t.string :name
      t.string :attribute

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_element_hidden_sections
  end
end

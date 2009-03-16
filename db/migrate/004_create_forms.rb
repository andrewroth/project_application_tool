class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.column :name, :string
      t.column :category, :string
      t.column :year, :integer
    end
  end

  def self.down
    drop_table :forms
  end
end

class AddHiddenToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :hidden, :boolean, :default=> false
  end

  def self.down
    remove_column :projects, :hidden
  end
end

class AddHiddenPage < ActiveRecord::Migration
  def self.up
    add_column Page.table_name, :hidden, :boolean
  end

  def self.down
    remove_column Page.table_name, :hidden
  end
end

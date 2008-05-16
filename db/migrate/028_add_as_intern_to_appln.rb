class AddAsInternToAppln < ActiveRecord::Migration
  def self.up
    add_column :applns, :as_intern, :boolean, :default => false
  end

  def self.down
    remove_column :applns, :as_intern
  end
end

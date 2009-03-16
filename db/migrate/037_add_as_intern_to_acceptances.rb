class AddAsInternToAcceptances < ActiveRecord::Migration
  def self.up
    add_column :acceptances, :as_intern, :boolean, :default => false
  end

  def self.down
    remove_column :acceptances, :as_intern
  end
end

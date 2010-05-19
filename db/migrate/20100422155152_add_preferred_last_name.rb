class AddPreferredLastName < ActiveRecord::Migration
  def self.up
    add_column :people, :preferred_last_name, :string
    rename_column :people, :preferred_name, :preferred_first_name
  end

  def self.down
    remove_column :people, :preferred_last_name
    rename_column :people, :preferred_first_name, :preferred_name
  end
end

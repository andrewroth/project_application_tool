class AddHideFromProfileToProjects < ActiveRecord::Migration
  def self.up
    add_column Project.table_name, :hide_from_profile, :boolean, :default => false
  end

  def self.down
    remove_column Project.table_name, :hide_from_profile
  end
end

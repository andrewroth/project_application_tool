class AddPulseNameToProjects < ActiveRecord::Migration
  def self.up
    add_column Project.table_name, :pulse_name, :string
  end

  def self.down
    remove_column Project.table_name, :pulse_name
  end
end

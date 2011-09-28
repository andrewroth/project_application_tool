class AddTimestampsToEmergAndFixPersonExtraTimestamp < ActiveRecord::Migration
  def self.up
    add_column PersonExtra.table_name, :created_at, :datetime
    change_column PersonExtra.table_name, :updated_at, :datetime
    add_column Emerg.table_name, :created_at, :datetime
    add_column Emerg.table_name, :updated_at, :datetime
  end

  def self.down
    remove_column PersonExtra.table_name, :created_at
    change_column PersonExtra.table_name, :updated_at, :string
    remove_column Emerg.table_name, :created_at
    remove_column Emerg.table_name, :updated_at
  end
end

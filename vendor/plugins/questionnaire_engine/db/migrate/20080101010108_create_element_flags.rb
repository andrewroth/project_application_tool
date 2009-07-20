class CreateElementFlags < ActiveRecord::Migration
  def self.up
    create_table ElementFlag.table_name do |t|
      t.column :element_id, :integer
      t.column :flag_id, :integer
    end
  end
  
  def self.down
    drop_table ElementFlag.table_name
  end
end

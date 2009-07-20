class CreatePageFlags < ActiveRecord::Migration
  def self.up
    create_table PageFlag.table_name do |t|
      t.column :page_id, :integer
      t.column :flag_id, :integer
      t.column :value, :boolean
    end
  end

  def self.down
    drop_table PageFlag.table_name
  end
end

class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table Flag.table_name do |t|
      t.column :name, :string
      t.column :element_txt, :string
      t.column :group_txt, :string
    end
  end

  def self.down
    drop_table Flag.table_name
  end
end

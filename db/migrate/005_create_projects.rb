class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column :title, :string
      t.column :description, :string
      t.column :start, :date
      t.column :end, :date
    end
  end

  def self.down
    drop_table :projects
  end
end

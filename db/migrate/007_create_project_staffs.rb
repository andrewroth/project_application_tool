class CreateProjectStaffs < ActiveRecord::Migration
  def self.up
    create_table :project_staffs do |t|
      t.column :project_id, :integer
      t.column :viewer_id, :integer
    end
  end

  def self.down
    drop_table :project_staffs
  end
end

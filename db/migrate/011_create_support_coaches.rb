class CreateSupportCoaches < ActiveRecord::Migration
  def self.up
    create_table :support_coaches do |t|
      t.column :project_id, :integer
      t.column :viewer_id, :integer
    end
  end

  def self.down
    drop_table :support_coaches
  end
end

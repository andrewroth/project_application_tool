class CreateProjectDirectors < ActiveRecord::Migration
  def self.up
    create_table :project_directors do |t|
      t.column :project_id, :integer
      t.column :viewer_id, :integer
    end
  end

  def self.down
    drop_table :project_directors
  end
end

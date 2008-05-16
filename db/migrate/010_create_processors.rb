class CreateProcessors < ActiveRecord::Migration
  def self.up
    create_table :processors do |t|
      t.column :project_id, :integer
      t.column :viewer_id, :integer
    end
  end

  def self.down
    drop_table :processors
  end
end

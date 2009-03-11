class CreateProcessorPiles < ActiveRecord::Migration
  def self.up
    create_table :processor_piles do |t|
      t.column :appln_id, :integer
      t.column :project_id, :integer
    end
  end

  def self.down
    drop_table :processor_piles
  end
end

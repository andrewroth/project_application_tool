class RemoveProcessorPiles < ActiveRecord::Migration
  def self.up
    # todo: make sure everythign in here is copied to the profile
    drop_table :processor_piles
  end

  def self.down
    create_table :processor_piles do |t|
      t.column :appln_id, :integer
      t.column :project_id, :integer
    end
  end
end

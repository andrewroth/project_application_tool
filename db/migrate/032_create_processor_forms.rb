class CreateProcessorForms < ActiveRecord::Migration
  def self.up
    create_table :processor_forms do |t|
      t.column :appln_id, :integer
      t.column :updated_at, :datetime
    end
  end
  
  def self.down
    drop_table :processor_forms
  end
end

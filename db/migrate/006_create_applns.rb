class CreateApplns < ActiveRecord::Migration
  def self.up
    create_table :applns do |t|
      t.column :form_id, :integer
      t.column :viewer_id, :integer
      t.column :status, :string
    end
  end

  def self.down
    drop_table :applns
  end
end

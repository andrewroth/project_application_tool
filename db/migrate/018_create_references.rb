class CreateReferences < ActiveRecord::Migration
  def self.up
    create_table :appln_references do |t|
      t.column :appln_id, :integer
      t.column :ref_type, :string
      t.column :email, :integer
      t.column :status, :string
      t.column :password, :string
    end
  end

  def self.down
    drop_table :appln_references
  end
end

class SetRefEmailString < ActiveRecord::Migration
  def self.up
    change_column :appln_references, :email, :string
  end

  def self.down
    change_column :appln_references, :email, :integer
  end
end

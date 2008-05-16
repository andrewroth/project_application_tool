class RenamePasswordInApplnReference < ActiveRecord::Migration
  def self.up
    rename_column :appln_references, :password, :access_key
  end

  def self.down
    rename_column :appln_references, :access_key, :password
  end
end

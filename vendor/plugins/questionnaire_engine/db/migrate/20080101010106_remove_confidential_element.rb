# removed because of the addition of the generic boolean
# table
# 
class RemoveConfidentialElement < ActiveRecord::Migration
  def self.up
    remove_column Element.table_name, :is_confidential
  end

  def self.down
    add_column Element.table_name, :is_confidential, :boolean
  end
end

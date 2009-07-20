class QeMaxQuestionLength < ActiveRecord::Migration
  def self.up
    add_column Element.table_name, :max_length, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column Element.table_name, :max_length
  end
end

class AddTimestampsToAnswers < ActiveRecord::Migration
  def self.up
    add_column Answer.table_name, "created_at", "datetime"
    add_column Answer.table_name, "updated_at", "datetime"
  end

  def self.down
    remove_column Answer.table_name, "created_at"
    remove_column Answer.table_name, "updated_at"
  end
end

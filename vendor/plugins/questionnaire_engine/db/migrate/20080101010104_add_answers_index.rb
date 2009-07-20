class AddAnswersIndex < ActiveRecord::Migration
  def self.up
    add_index(Answer.table_name, [:question_id, :instance_id], :unique => true)
  end

  def self.down
    remove_index Answer.table_name, :column => [:question_id, :instance_id]
  end
end

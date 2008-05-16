class AddQuestionnaireToForm < ActiveRecord::Migration
  def self.up
    add_column :forms, :questionnaire_id, :integer
  end

  def self.down
    remove_column :forms, :questionnaire_id
  end
end

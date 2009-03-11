class CreateAcceptances < ActiveRecord::Migration
  def self.up
    create_table :acceptances do |t|
      t.column :appln_id, :integer
      t.column :project_id, :integer
    end
  end

  def self.down
    remove_column :forms, :questionnaire_id
  end
end

class CreateReferenceAttributes < ActiveRecord::Migration
  def self.up
    begin
      create_table ReferenceAttribute.table_name do |t|
        t.column :reference_id, :integer
        t.column :questionnaire_id, :integer
      end
    rescue
      # some people already have this table from a previous migration
    end
  end

  def self.down
    drop_table ReferenceAttribute.table_name
  end
end

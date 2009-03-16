class CreateReportElements < ActiveRecord::Migration
  def self.up
    create_table :report_elements do |t|
      t.column :report_id, :integer
      t.column :element_id, :integer
      t.column :report_model_method_id, :integer
      t.column :position, :integer
      t.column :type, :string
    end
  end

  def self.down
    drop_table :report_elements
  end
end

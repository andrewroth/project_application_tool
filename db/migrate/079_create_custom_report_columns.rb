class CreateCustomReportColumns < ActiveRecord::Migration
  def self.up
    create_table :custom_report_columns do |t|
      t.column :custom_report_id, :integer
      t.column :order,            :integer
      t.column :model,            :string
      t.column :method,           :string
    end
  end

  def self.down
    drop_table :custom_report_columns
  end
end

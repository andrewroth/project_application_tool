class CreateReportModelMethods < ActiveRecord::Migration
  def self.up
    create_table :report_model_methods do |t|
      t.column :report_model_id, :integer
      t.column :method_s, :string
    end
  end

  def self.down
    drop_table :report_model_methods
  end
end

class CreateReportModels < ActiveRecord::Migration
  def self.up
    create_table :report_models do |t|
      t.column :model_s, :string
    end
  end

  def self.down
    drop_table :report_models
  end
end

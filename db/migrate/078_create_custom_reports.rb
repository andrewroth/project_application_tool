class CreateCustomReports < ActiveRecord::Migration
  def self.up
    create_table :custom_reports do |t|
      t.column :name,             :string
      t.column :description,      :string
      t.column :event_group_id,   :integer
    end
  end

  def self.down
    drop_table :custom_reports
  end
end

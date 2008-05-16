class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.column :title, :string
      t.column :event_group_id, :integer
    end
  end

  def self.down
    drop_table :reports
  end
end

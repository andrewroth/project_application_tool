class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.string :controller
      t.string :action
      t.text :message
      t.datetime :begin_time
      t.datetime :end_time
      t.boolean :ignore_begin
      t.boolean :ignore_end
      t.boolean :permanent

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end

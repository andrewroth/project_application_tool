class CreateNotificationAcknowledgments < ActiveRecord::Migration
  def self.up
    create_table :notification_acknowledgments do |t|
      t.integer :notification_id
      t.integer :viewer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notification_acknowledgments
  end
end

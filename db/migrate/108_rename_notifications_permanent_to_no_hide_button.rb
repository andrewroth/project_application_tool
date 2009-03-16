class RenameNotificationsPermanentToNoHideButton < ActiveRecord::Migration
  def self.up
    rename_column :notifications, :permanent, :no_hide_button
  end

  def self.down
    rename_column :notifications, :no_hide_button, :permanent
  end
end

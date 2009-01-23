class AddHtmlSupportToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :allow_html, :boolean, :default => false
  end

  def self.down
    remove_column :notifications, :allow_html
  end
end

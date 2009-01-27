class AddHtmlSupportToNotifications < ActiveRecord::Migration
  def self.up
    begin
      add_column :notifications, :allow_html, :boolean, :default => false
    rescue
    end
  end

  def self.down
    begin
      remove_column :notifications, :allow_html
    rescue
    end
  end
end

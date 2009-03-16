class RenameOrderToPosition < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `custom_report_columns` CHANGE `order` `position` int(11)"
  end

  def self.down
    execute "ALTER TABLE `custom_report_columns` CHANGE `position` `order` int(11)"
  end
end

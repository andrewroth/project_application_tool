class AddIdToProjectDonations < ActiveRecord::Migration
  def self.up
    add_column :project_donations, :id, :integer, :null => false
    execute "alter table project_donations change column id id int not null auto_increment key;"
  end

  def self.down
    remove_column :project_donations, :id
  end
end

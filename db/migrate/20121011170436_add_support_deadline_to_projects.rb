class AddSupportDeadlineToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :support_deadline, :date
  end

  def self.down
    remove_column :projects, :support_deadline
  end
end

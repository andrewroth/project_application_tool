class AddAcceptedByToAcceptances < ActiveRecord::Migration
  def self.up
    add_column :acceptances, :accepted_by_viewer_id, :integer
  end

  def self.down
    remove_column :acceptances, :locked_by_viewer_id
  end
end

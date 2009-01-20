class AddViewerIdToCimHrdbPerson < ActiveRecord::Migration
  def self.up
    add_column Person.table_name, :person_viewer_id, :integer
  end

  def self.down
    remove_column Person.table_name, :person_viewer_id
  end
end

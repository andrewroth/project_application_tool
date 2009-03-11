class AddHiddenToProject < ActiveRecord::Migration
  def self.up
    begin
      add_column :projects, :hidden, :boolean, :default=> false
    rescue
    end
  end

  def self.down
    begin
      remove_column :projects, :hidden
    rescue
    end
  end
end

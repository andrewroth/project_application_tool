class AddPrefsToAppln < ActiveRecord::Migration
  def self.up
    for i in 1..2
      add_column :applns, "preference#{i}_id", :integer
    end
  end

  def self.down
    for i in 1..2
      remove_column :applns, "preference#{i}_id"
    end
  end
end

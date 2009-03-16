class AddIndividualToPrepItems < ActiveRecord::Migration
  def self.up
    begin
    add_column :prep_items, :individual, :boolean, :default => false
    rescue
    end
  end

  def self.down
    begin
      remove_column :prep_items, :individual
      rescue
    end
  end
end

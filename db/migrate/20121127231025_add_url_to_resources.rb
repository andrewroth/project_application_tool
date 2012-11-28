class AddUrlToResources < ActiveRecord::Migration
  def self.up
    add_column :resources, :url, :string
  end

  def self.down
    #remove_column :resources, :url
  end
end

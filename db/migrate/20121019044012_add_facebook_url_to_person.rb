class AddFacebookUrlToPerson < ActiveRecord::Migration
  def self.up
    add_column Person.table_name, :facebook_url, :string
  end

  def self.down
    remove_column Person.table_name, :facebook_url, :string
  end
end

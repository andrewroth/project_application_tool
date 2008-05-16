class AddMotivationCodeToAcceptance < ActiveRecord::Migration
  def self.up
    add_column :acceptances, :motivation_code, :string, :default => false
  end

  def self.down
    remove_column :acceptances, :motivation_code
  end
end

class AddSupportToAcceptance < ActiveRecord::Migration
  def self.up
    add_column :acceptances, :support_coach_id, :integer
    add_column :acceptances, :support_claimed, :float
  end

  def self.down
    remove_column :acceptances, :support_coach_id
    remove_column :acceptances, :support_claimed
  end
end

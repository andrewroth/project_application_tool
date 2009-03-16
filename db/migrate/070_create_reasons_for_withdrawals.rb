class CreateReasonsForWithdrawals < ActiveRecord::Migration
  def self.up
    create_table :reason_for_withdrawals do |t|
      t.column :blurb, :string
    end
  end

  def self.down
    drop_table :reason_for_withdrawals
  end
end

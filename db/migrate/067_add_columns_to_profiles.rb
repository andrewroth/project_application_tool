# adds a bunch of columns for the various objects

class AddColumnsToProfiles < ActiveRecord::Migration
  def self.up

    # Applying
    add_column :profiles, :status, :string
    add_column :profiles, :locked_by, :integer
    add_column :profiles, :locked_at, :datetime
    add_column :profiles, :completed_at, :datetime

    # Acceptance
    add_column :profiles, :accepted_by, :integer
    add_column :profiles, :accepted_at, :datetime

    # Withdrawal
    add_column :profiles, :withdrawn_by, :integer
    add_column :profiles, :withdrawn_at, :datetime
    add_column :profiles, :status_when_withdrawn, :string
    add_column :profiles, :class_when_withdrawn, :string
    add_column :profiles, :reason_id, :integer
    add_column :profiles, :reason_notes, :string

    # indexes on anything that might be in a select / join on
    add_index :profiles, :accepted_by
    add_index :profiles, :locked_by
    add_index :profiles, :withdrawn_by
    add_index :profiles, :reason_id
  end

  def self.down
    # TODO
  end
end

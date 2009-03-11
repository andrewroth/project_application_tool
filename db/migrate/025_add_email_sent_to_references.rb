class AddEmailSentToReferences < ActiveRecord::Migration
  def self.up
    add_column :appln_references, :email_sent, :boolean, :default => false
  end

  def self.down
    remove_column :appln_references, :email_sent
  end
end

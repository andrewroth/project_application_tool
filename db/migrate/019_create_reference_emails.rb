class CreateReferenceEmails < ActiveRecord::Migration
  def self.up
    create_table :reference_emails do |t|
      t.column :email_type, :string
      t.column :year, :integer
      t.column :text, :text
    end
  end

  def self.down
    drop_table :reference_emails
  end
end

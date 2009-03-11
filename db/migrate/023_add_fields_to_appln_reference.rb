class AddFieldsToApplnReference < ActiveRecord::Migration
  def self.up
    add_column :appln_references, "email_sent_at",  :datetime
    add_column :appln_references, "is_staff",       :boolean
    add_column :appln_references, "title",          :string
    add_column :appln_references, "first_name",     :string
    add_column :appln_references, "last_name",      :string
    add_column :appln_references, "accountNo",      :string
    add_column :appln_references, "home_phone",     :string
    add_column :appln_references, "submitted_at",   :datetime
    add_column :appln_references, "created_at",     :datetime
    add_column :appln_references, "updated_at",     :datetime
    add_column :appln_references, "created_by_id",  :integer
    add_column :appln_references, "updated_by_id",  :integer
    add_column :appln_references, "mail",           :boolean, :default => false
  end

  def self.down
    remove_column :appln_references, "email_sent_at"
    remove_column :appln_references, "is_staff"
    remove_column :appln_references, "title"
    remove_column :appln_references, "first_name"
    remove_column :appln_references, "last_name"
    remove_column :appln_references, "accountNo"
    remove_column :appln_references, "home_phone"
    remove_column :appln_references, "submitted_at"
    remove_column :appln_references, "created_at"
    remove_column :appln_references, "updated_at"
    remove_column :appln_references, "created_by_id"
    remove_column :appln_references, "updated_by_id"
    remove_column :appln_references, "mail"
  end
end

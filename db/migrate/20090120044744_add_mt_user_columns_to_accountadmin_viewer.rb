class AddMtUserColumnsToAccountadminViewer < ActiveRecord::Migration
  def self.has_column(s)
    Viewer.column_names.include?(s.to_s)
  end

  def self.up
    change_table(Viewer.table_name) do |t|
      t.string   "remember_token" unless has_column("remember_token")
      t.datetime "remember_token_expires_at" unless has_column("remember_token_expires_at")

      t.boolean  "email_validated" unless has_column("email_validated")
      t.boolean  "developer" unless has_column("developer")
      t.string   "facebook_hash" unless has_column("facebook_hash")
      t.string   "facebook_username" unless has_column("facebook_username")
    end
  end

  def self.down
    change_table(Viewer.table_name) do |t|
      t.remove   "remember_token"
      t.remove   "remember_token_expires_at"

      t.remove   "email_validated"
      t.remove   "developer"
      t.remove   "facebook_hash"
      t.remove   "facebook_username"
    end
  end
end

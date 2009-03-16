class AddMtUserColumnsToAccountadminViewer < ActiveRecord::Migration
  def self.up
    change_table(Viewer.table_name) do |t|
      t.string   "remember_token"
      t.datetime "remember_token_expires_at"

      t.boolean  "email_validated"
      t.boolean  "developer"
      t.string   "facebook_hash"
      t.string   "facebook_username"
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

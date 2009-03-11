class UpdateFormElements < ActiveRecord::Migration
  # now a single type for PeerReference, StaffReference, etc.
  def self.up
    execute %{update #{Element.table_name}
              set type = 'Reference'
              where type like '%Reference%'}
  end

  def self.down
  end
end

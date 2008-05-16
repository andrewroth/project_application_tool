class AddViewerIdToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :viewer_id, :integer
    
    # add viewer_id
    Acceptance.find(:all).each do |ac|
      begin
        ac.viewer_id = ac.appln.viewer_id
        ac.save!
      rescue
      end
    end
  end

  def self.down
    remove_column :profiles, :viewer_id
  end
end

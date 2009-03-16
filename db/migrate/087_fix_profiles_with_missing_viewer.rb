class FixProfilesWithMissingViewer < ActiveRecord::Migration
  def self.up
    for p in Profile.find(:all)
      if p.viewer_id.nil?
        p.viewer_id = p.appln.viewer_id
	p.save!
      end
    end
  end

  def self.down
  end
end

class FixDuplicateApplns < ActiveRecord::Migration
  def self.up
    return unless Appln.count > 0

    Viewer.find(:all).each do |v|
      apps = v.applns.find(:all)
      first_app = apps[0] if !apps.empty?

      puts "#{v.name} has #{apps.length} apps"
      
      for i in 1..apps.length-1
        app = apps[i]
        
        # switch all acceptances to first app
        for acceptance in app.acceptances
          puts "  switching acceptance from non-primary app #{acceptance.appln_id} to primary app #{first_app.id}"
          acceptance.appln_id = first_app.id
          acceptance.save!
        end

        # orphin the app
        app.viewer_id = nil
        app.save!
      end
    end
    
    # just for good measure, set the viewer_id again
    Acceptance.find(:all).each do |ac|
      begin
        ac.viewer_id = ac.appln.viewer_id
        ac.save!
      rescue
      end
    end    
  end

  def self.down
  end
end

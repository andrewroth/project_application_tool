class FixCreatedViewers < ActiveRecord::Migration
  def self.up
    vs = Viewer.find_all_by_viewer_isActive false
    ag_all = Accessgroup.find_by_accessgroup_key '[accessgroup_key1]'

    n = 0
    for v in vs
      n += 1

      v.language_id = 1
      v.viewer_isActive = true
      v.accountgroup_id = 15
      v.save!

      v.accessgroups << ag_all unless v.accessgroups.detect{ |ag| ag.id == ag_all.id }
    end

    puts "Fixed #{n} cim_hrdb accounts"
  end

  def self.down
  end
end

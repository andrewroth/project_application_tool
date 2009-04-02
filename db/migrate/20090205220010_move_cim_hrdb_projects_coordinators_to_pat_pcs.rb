class MoveCimHrdbProjectsCoordinatorsToPatPcs < ActiveRecord::Migration
  def self.up
    pc_key = '[accessgroup_projects_coordinator]'
    pc_ag = Accessgroup.find_by_accessgroup_key(pc_key)
    if pc_ag
      for v in pc_ag.viewers
        ProjectsCoordinator.create! :viewer_id => v.id
      end
    end
  end

  def self.down
  end
end

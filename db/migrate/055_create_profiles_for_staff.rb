class CreateProfilesForStaff < ActiveRecord::Migration
  @@tables = [ ProjectDirector, ProjectAdministrator, ProjectStaff ]

  def self.up
    loop_staff do |assignment|
      profile = Profile.find_by_viewer_id_and_project_id assignment.viewer_id, assignment.project_id
      if profile
        puts "  Already have a staff profile"
      else
        puts "  Created a profile"
        profile = StaffProfile.create :viewer_id => assignment.viewer_id, :project_id => assignment.project_id
      end
    end
  end

  def self.down
    loop_staff do |assignment|
      profile = Profile.find_by_viewer_id_and_project_id assignment.viewer_id, assignment.project_id
      if profile
        puts "  Deleting staff profile"
        profile.destroy
      else
        puts "  Couldn't find profile"
      end
    end
  end

  def self.loop_staff
    @@tables.each do |table|
      puts '- ' + table.name
      table.find(:all).each do |assignment|
        puts "#{assignment.viewer.name} for #{table}"
        yield assignment
      end
    end
  end
end


require 'migration_helper.rb'

class ModifyProjectsCoordinatorKey < ActiveRecord::Migration
  @new_key = '[accessgroup_projects_coordinator]'
  @old_key = '[accessgroup_key47]'
  @label =  'SPT - Projects Coordinator'
  
  def self.up
    change_key(@old_key, @new_key, @label)
  end

  def self.down
    change_key(@new_key, @old_key, @label)
  end
end

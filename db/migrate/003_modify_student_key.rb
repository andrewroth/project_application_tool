require 'migration_helper.rb'

class ModifyStudentKey < ActiveRecord::Migration
  @new_key = '[accessgroup_student]'
  @old_key = '[accessgroup_key46]'
  @label =  'SPT - Student'
  
  def self.up
    change_key(@old_key, @new_key, @label)
  end

  def self.down
    change_key(@new_key, @old_key, @label)
  end
end

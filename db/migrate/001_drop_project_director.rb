# NOTE: (Nov 10 2006) We don't need to drop this, Russ renamed it to
#  projects coordinator
# 
# Note this is assuming that
# the project director is an accessgroup in the db -- it 
# was in the db created by Russ ~Sept 06 2006
# 
# Well, we don't need a project director access group because
# we made the decision to put project director in a table in
# the spt (That's because you're a project director for a
# specific *year* and it's silly to have a ton of access groups
# in CIM intranet.)
# 
# The project director accessgroup has is 47.
# 
class DropProjectDirector < ActiveRecord::Migration
  def self.up
#    # drop "project director"
#    # first remove it from accountadmin_accessgroup
#    Accessgroup.delete 47
#    
#    # delete all translation entries
#    MultilingualLabel.delete_all "label_key = '[accessgroup_key47]'"
#    
#    # delete all entries from accountadmin_vieweraccessgroup
#    Vieweraccessgroup.delete_all "accessgroup_id = 47"
  end
  
  def self.down
#    raise IrreversibleMigration
  end
end

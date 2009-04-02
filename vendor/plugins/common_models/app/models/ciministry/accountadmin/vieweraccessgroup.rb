class Vieweraccessgroup < Accountadmin
  set_primary_key "vieweraccessgroup_id"
  
  belongs_to :viewer
  belongs_to :accessgroup
end

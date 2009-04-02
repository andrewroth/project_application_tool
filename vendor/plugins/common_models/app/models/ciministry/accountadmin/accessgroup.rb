class Accessgroup < Accountadmin
  set_primary_key "accessgroup_id"
  
  has_many :vieweraccessgroup
  has_many :viewers, :through => :vieweraccessgroup
end

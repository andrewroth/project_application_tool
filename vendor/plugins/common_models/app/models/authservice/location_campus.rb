class LocationCampus < LocationAlias
  belongs_to :alias, :polymorphic => true
  before_save :set_alias_type

  def campus() self.send('alias') end
  def name() campus ? campus.campus_desc : 'unknown' end
  def set_alias_type() self.alias_type = 'Campus' end
end


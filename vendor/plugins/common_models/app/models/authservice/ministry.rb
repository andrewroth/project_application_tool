class Ministry < AuthserviceBase
  acts_as_tree :order => "name"
  
  has_many :location_groups

  validates_presence_of   :name

  def to_s() name end
end


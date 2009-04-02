class Location < AuthserviceBase
  acts_as_tree :order => "name"
  #is_tree_base :class => Location

  def self.subtypes() [ LocationFolder, LocationCampus ] end
  def to_s() name end
end

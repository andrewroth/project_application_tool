# advance declarations
class LocationGroup < AuthserviceBase
end
class LocationGroupNode < LocationGroup
end
class LocationGroupAlias < LocationGroup
end

class LocationGroup < AuthserviceBase
  acts_as_tree

  def self.subtypes() [ LocationGroupNode, LocationGroupAlias ] end
  def to_s() name end
end

# again hack to get rails to load sub classes otherwise LocationGroup.find :all
# won't return objects that are instances of any of the subclasses
LocationGroup.subtypes

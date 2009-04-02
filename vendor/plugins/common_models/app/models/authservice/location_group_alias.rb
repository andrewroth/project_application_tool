# this is a hack to fix something weird in rails
# it seems the subtypes of location aren't loaded
# unless i explicitly do this
Location.subtypes

class LocationGroupAlias < LocationGroup
  belongs_to :alias, :polymorphic => true

  def name() self.alias.name + ' (alias)' end

  def children
    aliases_children_as_aliases = self.alias.children.collect{ |c|
      LocationGroupAlias.new(:alias_type => c.class.name, :alias_id => c.id)
    }
    super + aliases_children_as_aliases
  end
end

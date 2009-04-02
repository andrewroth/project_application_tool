class Permission < Node
  acts_as_tree :order => "name"

  validates_presence_of   :name

  def to_s() name end
end

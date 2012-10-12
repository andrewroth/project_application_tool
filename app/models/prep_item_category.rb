class PrepItemCategory < ActiveRecord::Base
  def <=>(other) self.title <=> other.title end
end

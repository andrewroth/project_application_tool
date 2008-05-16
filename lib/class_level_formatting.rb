require 'formatting'

module ClassLevelFormatting
  def self.included(base)
    base.extend(Formatting)
  end
end

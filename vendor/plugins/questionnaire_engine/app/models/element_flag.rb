 class ElementFlag < ActiveRecord::Base
  set_table_name "#{QE.prefix}element_flags"
  
  belongs_to :flag
  belongs_to :subject, :class_name => 'Element', :foreign_key => 'element_id'
  belongs_to :element
  
  def ElementFlag.cache
    @cache ||= FlagCache.new(self)
  end
end

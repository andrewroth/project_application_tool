class PageFlag < ActiveRecord::Base
  set_table_name "#{QE.prefix}page_flags"
  
  belongs_to :flag
  belongs_to :subject, :class_name => 'Page', :foreign_key => 'page_id'
  belongs_to :page, :class_name => 'Page', :foreign_key => 'page_id'

  def PageFlag.cache
    @cache ||= FlagCache.new(self)
  end
end

class PageElement < ActiveRecord::Base
  set_table_name "#{QE.prefix}page_elements"
  belongs_to  :page
  belongs_to  :element
  acts_as_list :scope => :page_id
end

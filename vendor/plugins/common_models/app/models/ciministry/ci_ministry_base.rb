class CiMinistryBase < ActiveRecord::Base  
  self.abstract_class = true
  acts_as_database_base_class :database => 'ciministry'

  def self.pluralize_table_names() false end
end


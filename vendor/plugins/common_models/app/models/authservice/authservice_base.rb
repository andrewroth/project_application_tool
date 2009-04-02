class AuthserviceBase < Node
  self.abstract_class = true
  acts_as_database_base_class :database => 'authservice'
  
  def table_name_prefix() '' end
end

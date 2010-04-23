class Viewer < ActiveRecord::Base
  load_mappings
  include Common::Core::User
  include ViewerMethods
  set_table_name User.table_name
  set_primary_key User.primary_key
end

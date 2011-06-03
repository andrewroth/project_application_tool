class Access < ActiveRecord::Base
  load_mappings

  include Legacy::Accountadmin::Access
end


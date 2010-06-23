class AccountadminAccessgroup < ActiveRecord::Base
  load_mappings
  include Legacy::Accountadmin::AccountadminAccessgroup
end

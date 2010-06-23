class AccountadminLanguage < ActiveRecord::Base
  load_mappings
  include Legacy::Accountadmin::AccountadminLanguage
end

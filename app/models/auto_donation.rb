class AutoDonation < ActiveRecord::Base
  load_mappings
  include Common::Core::Ca::AutoDonation
  set_table_name "project_donations"
end

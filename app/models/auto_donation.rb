class AutoDonation < ActiveRecord::Base
  set_table_name "project_donations"
  
  def motivation_code() participant_motv_code end
end

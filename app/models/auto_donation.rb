class AutoDonation < ActiveRecord::Base
  set_table_name "project_donations"
  
  def motivation_code() participant_motv_code end
  def status() '' end

  # remove all traces of original_amount, since it's always the same^M
  def original_amount() nil end
  def [](v)
    return nil if v.to_sym == :original_amount
    super
  end
end

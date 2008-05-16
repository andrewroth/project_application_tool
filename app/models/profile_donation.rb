# not presently used (-AR)
class ProfileDonation < ActiveRecord::Base
  belongs_to :profile
  belongs_to :donation
  
  $last_profile_donation_initialize ||= 1.year.ago # force update
  
  def self.donations(pid)
     AutoDonation.find_by_sql("" +
      "SELECT #{AutoDonation.columns.collect{ |ad| "d."+ad.name }.join(', ')}, p.id as profile_id " +
      "FROM profiles p, #{AutoDonation.table_name} d " +
      'WHERE d.participant_motv_code = p.motivation_code ' +
      "   and p.project_id = #{pid} " + 
      'ORDER BY d.donation_date') + ManualDonation.find_by_sql("" +
      "SELECT #{ManualDonation.columns.collect{ |ad| "d."+ad.name }.join(', ')}, p.id as profile_id " +
      "FROM profiles p, #{ManualDonation.table_name} d " +
      'WHERE d.motivation_code = p.motivation_code ' +
      "   and p.project_id = #{pid} " + 
      'ORDER BY d.created_at')
  end

  def self.cache(pid)
    cache = {}
    for donation in donations(pid)
      cache[donation.profile_id] ||= []
      cache[donation.profile_id] << donation
    end
    cache
  end
  
  def ProfileDonation.potentially_initialize
    return $last_profile_donation_initialize unless $last_profile_donation_initialize <= 24.hours.ago
    #return Time.now # REMOVE ME WHEN COMMITTING!
    logger.info "Updating donations (last update was #{$last_profile_donation_initialize}"
    $last_profile_donation_initialize = Time.now
    
    ProfileDonation.delete_all
    
    # probably want to cache this
    profiles_cache = Profile.find :all
    
    # create a profile_donation for each manual & auto donation
    [ ManualDonation, AutoDonation ].each do |table|
      create_profile_donations_for table, profiles_cache
    end
    
  end
  
  def ProfileDonation.create_profile_donations_for(donation_class, profiles_cache)
    # create a profile_donation for each auto donation
    donation_class.find(:all).each do |d|
      profile = profiles_cache.find { |p| p.motivation_code == d.motivation_code }
      next unless profile
      
      uscore_name = donation_class.name.underscore
      "profile_#{uscore_name}".camelize.constantize.create :profile_id => profile.id,
        :"#{uscore_name}_id" => d.id
    end
  end
end

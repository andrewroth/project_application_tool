class CurrentAddress < CimHrdbAddress
  load_mappings
  doesnt_implement_attributes :address2 => '', :start_date => 'Time.now', :end_date => '10.years.from_now',
        :email_validated => 'false', :email => '', :dorm => '', :room => ''

  validates_format_of   _(:email),
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'must be valid'
  
  def address_type() 'current' end
end

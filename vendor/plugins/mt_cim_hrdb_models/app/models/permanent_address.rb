class PermanentAddress < CimHrdbAddress
  load_mappings

  doesnt_implement_attributes :address2 => '', :start_date => 'Time.now', :end_date => '10.years.from_now',
          :email_validated => 'false', :email => '', :alternate_phone => '', :dorm => '', :room => ''

  def address_type() 'permanent' end
end

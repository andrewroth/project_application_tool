class Emerg < CimHrdb
  BLOOD_TYPES = %w(A B AB O Unknown)
  BLOOD_TYPE_RH = [ "Positive", "Negative", "Unknown" ]

  set_primary_key "emerg_id"
  
  belongs_to :person
  belongs_to :health_province, :class_name => 'Province'
  
  def passport_number
    self.emerg_passportNum
  end
  
  def passport_origin
    self.emerg_passportOrigin
  end
  
  def passport_expiry
    self.emerg_passportExpiry
  end
  
  def contact_name
    self.emerg_contactName
  end
  
  def contact_relationship
    self.emerg_contactRship
  end
  
  def contact_home_phone
    self.emerg_contactHome
  end
  
  def contact_work_phone
    self.emerg_contactWork
  end
  
  def contact_mobile_phone
    self.emerg_contactMobile
  end
  
  def contact_email
    self.emerg_contactEmail
  end
  
  def contact2_name
    self.emerg_contact2Name
  end
  
  def contact2_relationship
    self.emerg_contact2Rship
  end
  
  def contact2_home_phone
    self.emerg_contact2Home
  end
  
  def contact2_work_phone
    self.emerg_contact2Work
  end
  
  def contact2_mobile_phone
    self.emerg_contact2Mobile
  end
  
  def contact2_email
    self.emerg_contact2Email
  end
  
   def birthdate
    self.emerg_birthdate
  end
  
  def medical_notes
    self.emerg_medicalNotes
  end

  def health_province_shortDesc
    health_province.province_shortDesc if health_province
  end

  def health_province_longDesc
    health_province.province_desc if health_province
  end

  def extended_medical_plan_number
    self.medical_plan_number
  end

  def extended_medical_plan_carrier
    self.medical_plan_carrier
  end
end

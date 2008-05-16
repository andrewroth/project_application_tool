class ManualDonation < ActiveRecord::Base
  Infinity = 1/0.0

  belongs_to :acceptance
  belongs_to :donation_type_obj, :class_name => 'DonationType', :foreign_key => 'donation_type_id'
  
  validates_presence_of :motivation_code
  validates_presence_of :donor_name
  validates_presence_of :donation_type_id
  validates_presence_of :original_amount
  validates_presence_of :amount 
  # following two checks removed per Russ and Susan's request, so that they can input negative numbers
  #validates_inclusion_of :original_amount, :in => 1..Infinity, :message => " - Please include the amount (at least $1)."
  #validates_inclusion_of :amount, :in => 1..Infinity, :message => " - Please include the amount (at least $1)."
  
  def donation_type
    self[:donation_type]
  end
  
  def donation_date
    self[:donation_date]
  end
  
  def [](key)
    key = key.to_s
    if key == "donation_type"
     !donation_type_obj.nil? ? donation_type_obj.description : ''
    elsif key == "donation_date"
      created_at
    else
      super
    end
  end
  
end

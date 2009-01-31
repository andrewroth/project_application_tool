class ManualDonation < ActiveRecord::Base
  STATUSES = %w(pending received invalid)
  LIST_COLUMNS = %w(motivation_code created_at donor_name donation_type original_amount conversion_rate amount status)
  LIST_TYPES = { 'original_amount' => 'currency', 'amount' => 'currency' }

  Infinity = 1/0.0

  belongs_to :acceptance
  belongs_to :donation_type_obj, :class_name => 'DonationType', :foreign_key => 'donation_type_id'
  
  validates_presence_of :motivation_code
  validates_presence_of :donor_name
  validates_presence_of :donation_type_id
  validates_presence_of :amount 
  # following two checks removed per Russ and Susan's request, so that they can input negative numbers
  #validates_inclusion_of :original_amount, :in => 1..Infinity, :message => " - Please include the amount (at least $1)."
  #validates_inclusion_of :amount, :in => 1..Infinity, :message => " - Please include the amount (at least $1)."
  
  # this is rails 2.2 specific, since this branch might be merged with trunk
  # yet, will leave it commented
  #has_many :profiles, :foreign_key => 'motivation_code', :primary_key => 'motivation_code'

  def donation_type
    self[:donation_type]
  end
  
  def donation_date
    self[:donation_date]
  end
  
  def conversion_rate_display
    donation_type == 'USDMANUAL' ? conversion_rate : (conversion_rate == 1.0 ? '' : conversion_rate)
  end

  def original_amount_display
    donation_type == 'USDMANUAL' ? original_amount : (original_amount == amount ? '' : original_amount)
  end

  #def amount
  #  donation_type == 'USDMANUAL' ? original_amount * conversion_rate : self[:amount]
  #end

  def uses_conversion?
    self[:original_amount] != self[:amount]
  end

  def status
    donation_type == 'USDMANUAL' ? self[:status] : ''
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

  def before_save
    original_amount ||= amount
    conversion_rate ||= 1.0
  end
end

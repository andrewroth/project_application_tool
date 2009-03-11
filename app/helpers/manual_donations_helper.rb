module ManualDonationsHelper

  def get_donation_types
    @donation_types = DonationType.find(:all, :order => "description").map {|t| [t.description, t.id]}
  end
end

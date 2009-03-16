class DonationType < ActiveRecord::Base
  has_many :manual_donations
end

class ManualDonation < ActiveRecord::Base
  load_mappings
  include Common::Core::Ca::ManualDonation
  STATUSES = self.STATUSES
  LIST_COLUMNS = self.LIST_COLUMNS
  LIST_TYPES = self.LIST_TYPES

  belongs_to :acceptance
end

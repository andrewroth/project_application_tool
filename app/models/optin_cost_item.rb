class OptinCostItem < ActiveRecord::Base
  belongs_to :cost_item
  belongs_to :profile

  after_destroy { |record|
    record.profile.update_costing_total_cache
  }

  after_save { |record|
    record.profile.update_costing_total_cache
  }
end

class OptinCostItem < ActiveRecord::Base
  belongs_to :cost_item
  belongs_to :profile
end

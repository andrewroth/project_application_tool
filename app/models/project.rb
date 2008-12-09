class Project < ActiveRecord::Base
  has_many :project_staffs
  has_many :project_directors
  has_many :project_administrators
  has_many :support_coaches
  has_many :processors
  
  has_many :profiles
  has_many :withdrawns
  has_many :acceptances
  has_many :applyings
  has_many :cost_items
  
  has_many :processor_pile
  
  belongs_to :event_group

  def name() title end
  
  def year
    return start.year
  end
  
  def all_cost_items(eg)
    eg_cost_items = eg.cost_items.select{|ci| ci.class == YearCostItem }
    (eg_cost_items + cost_items).uniq
  end
end

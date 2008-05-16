class CostItem < ActiveRecord::Base
  has_many :optins, :class_name => 'OptinCostItem'

  def shortDesc
    "#{description} #{self.class == YearCostItem ? '(year-item)' : ''} " + 
    "$#{amount} (#{optional ? 'optional' : 'mandatory'})"
  end

  def description
    d = self[:description]
    d.nil? || d.empty? ? 'no description' : d
  end

  def CostItem.yearly(year)
    find_all_by_year_and_type(year, 'YearCostItem')
  end

# year cost items first.  sort year cost items by description
# project cost items next. sort project cost items by project title
# acceptance cost items next.  sort acceptance cost items by description
# 
  def <=>(other)
    compare_primary = self.primary_sort_val <=> other.primary_sort_val
    return compare_primary if compare_primary != 0
    return secondary_sort_val <=> other.secondary_sort_val
  end

  def secondary_sort_val
    case self.class.name
      when "YearCostItem"
        return description
      when "ProjectCostItem"
        return (if project then project.title else "[choose a project]" end)
      when "ProfileCostItem"
        return description
    end
  end

  def primary_sort_val
    case self.class.name
      when 'YearCostItem'
        0
      when "ProjectCostItem"
        1
      when "ProfileCostItem"
        2
    end
  end  
end

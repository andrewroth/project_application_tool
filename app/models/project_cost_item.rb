# a cost-item that applies to a specific project
# 
class ProjectCostItem < CostItem
  belongs_to :project

  def short_type() "project" end

  def update_costing_total_cache
    ProjectCostItem.update_costing_total_cache_by_project [ project ]
  end

  def self.update_costing_total_cache_by_project(projects, verbose = false)
    # update all profiles in project
    profiles = Profile.find_all_by_project_id projects.collect(&:id), :include => [ :optin_cost_items, :profile_cost_items, :project ],
                  :select => "#{CostItem.table_name}.amount, #{CostItem.table_name}.optional, #{CostItem.table_name}.type, #{Project.table_name}.event_group_id, #{OptinCostItem.table_name}.cost_item_id", 
                  :conditions => "#{Profile.table_name}.type != 'Applying'"

    # sort by event_group so that we can reuse the same eg model instance as much as possible
    profiles.sort!{ |p1,p2| p1.project.event_group_id <=> p2.project.event_group_id }
    eg = nil
    
    if verbose
      puts "Updating costing cache for #{profiles.length} profiles."
    end

    n = 0
    for profile in profiles
      if verbose
        n += 1
        if n % 100 == 0
          STDOUT.print('.')
          STDOUT.flush
        end
      end

      # use existing eg if possible to keep AR cache
      if eg.nil? || eg.id.to_s != profile.project.event_group_id.to_s
       eg = EventGroup.find profile.project.event_group_id
      end

      profile.update_costing_total_cache(eg, true)
    end
    puts if verbose

    true
  end
end

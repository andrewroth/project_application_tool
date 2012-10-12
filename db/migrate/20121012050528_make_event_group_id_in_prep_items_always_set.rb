class MakeEventGroupIdInPrepItemsAlwaysSet < ActiveRecord::Migration
  def self.up
    PrepItem.find(:all, :conditions => "event_group_id is not null").each do |prep_item|
      next unless prep_item.event_group # event_group may have been deleted
      prep_item.event_group.projects.each do |project|
        prep_item.projects << project unless prep_item.projects.include?(project)
      end
    end
    PrepItem.find(:all, :conditions => "event_group_id is null").each do |prep_item|
      if prep_item.projects.first
        PrepItem.update_all("event_group_id = #{prep_item.projects.first.event_group_id}", "id = #{prep_item.id}")
      end
    end
  end

  def self.down
  end
end

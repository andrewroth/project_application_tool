class AddEventGroupId < ActiveRecord::Migration
  def self.add_models() [ :travel_segments, :cost_items, :projects, :feedbacks, 
                  :forms, :reason_for_withdrawals, :reference_emails, :tags
                ]
  end

  def self.up
    add_models.each do |m| 
      add_column m, :event_group_id, :integer 
      add_index m, :event_group_id
    end
  end

  def self.down
    add_models.each do |m| 
      begin
        remove_index m, :event_group_id
        remove_column m, :event_group_id 
      rescue
      end
    end
  end
end

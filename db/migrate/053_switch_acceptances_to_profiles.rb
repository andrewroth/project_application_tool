# so that it doesn't die switching cost item types
class AcceptanceCostItem < ProfileCostItem
end

class SwitchAcceptancesToProfiles < ActiveRecord::Migration
  def self.up
    Profile.transaction do
      # we are going to use profiles teable instead of acceptances
      rename_table :acceptances, :profiles

      # and add a type column
      add_column :profiles, :type, :string
    
      # rename a few tables and acceptance_id columns to be profile_id

      rename_table :acceptance_travel_segments, :profile_travel_segments
      rename_column :profile_travel_segments, :acceptance_id, :profile_id

      rename_column :cost_items, :acceptance_id, :profile_id

      rename_column :optin_cost_items, :acceptance_id, :profile_id

      # put the profiles type to 'acceptance' by default
      Profile.find(:all).each do |p|
        p[:type] = 'Acceptance'
        p.save!
      end

      # also change all travel segments of type AcceptanceCostItem to ProfileCostItem
      CostItem.find_all_by_type('AcceptanceCostItem').each do |ts|
        ts[:type] = 'ProfileCostItem'
        ts.save!
      end
    end
  end

  def self.down
    Profile.transaction do
      remove_column :profiles, :type
      rename_table :profiles, :acceptances

      rename_column :profile_travel_segments, :profile_id, :acceptance_id
      rename_table :profile_travel_segments, :acceptance_travel_segments

      rename_column :cost_items, :profile_id, :acceptance_id

      rename_column :optin_cost_items, :profile_id, :acceptance_id
    end
  end
end

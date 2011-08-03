class AddUrlCostInstructionsCostPhraseToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :url, :string
    add_column :event_groups, :cost_item_instructions, :string
    add_column :event_groups, :cost_item_phrase, :string
  end

  def self.down
  end
end

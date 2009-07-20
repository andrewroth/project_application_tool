class CreateSummaryElementFlag < ActiveRecord::Migration
  @@name = 'in_summary_view'
  def self.up
    f = Flag.find_by_name @@name
    if f.nil?
      f = Flag.create :name => @@name,
        :element_txt => 'This element is part of the summary view.',
        :group_txt => 'All elements in this group are part of the summary view'
    end
  end

  def self.down
    f = Flag.find_by_name @@name
    f.destroy if !f.nil?
  end
end

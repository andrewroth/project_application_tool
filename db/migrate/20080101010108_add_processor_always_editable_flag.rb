class AddProcessorAlwaysEditableFlag < ActiveRecord::Migration
  @@name = 'processor_always_editable'
  def self.up
    f = Flag.find_by_name @@name
    if f.nil?
      f = Flag.create :name => @@name,
        :element_txt => 'Processors can edit this field',
        :group_txt => 'Processors can edit all fields in this group'
    end
  end

  def self.down
    f = Flag.find_by_name @@name
    f.destroy if !f.nil?
  end
end

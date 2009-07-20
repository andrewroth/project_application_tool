class CreateAlwaysEditable < ActiveRecord::Migration
  @@name = 'always_editable'
  def self.up
    f = Flag.find_by_name @@name
    if f.nil?
      f = Flag.create :name => @@name,
        :element_txt => 'This element is always editable',
        :group_txt => 'All elements in this group are always editable'
    end
  end

  def self.down
    f = Flag.find_by_name @@name
    f.destroy if !f.nil?
  end
end

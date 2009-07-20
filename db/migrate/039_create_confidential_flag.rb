class CreateConfidentialFlag < ActiveRecord::Migration
  @@name = 'confidential'
  def self.up
    f = Flag.find_by_name @@name
    if f.nil?
      f = Flag.create :name => @@name,
        :element_txt => 'This element is confidential',
        :group_txt => 'All elements in this group are confidential'
    end
  end

  def self.down
    f = Flag.find_by_name @@name
    f.destroy if !f.nil?
  end
end

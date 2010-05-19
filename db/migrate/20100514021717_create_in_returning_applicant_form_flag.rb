class CreateInReturningApplicantFormFlag < ActiveRecord::Migration
  @@name = 'in_returning_applicant_form'
  def self.up
    f = Flag.find_by_name @@name
    if f.nil?
      f = Flag.create :name => @@name,
        :element_txt => "This element appears in the returning applicant's form.",
        :group_txt => "All elements in this group are in the returning applicant's form"
    end
  end

  def self.down
    f = Flag.find_by_name @@name
    f.destroy if !f.nil?
  end

end

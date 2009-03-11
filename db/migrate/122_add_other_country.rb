class AddOtherCountry < ActiveRecord::Migration
  def self.up
    oc = Country.create :country_desc => 'Other', :country_shortDesc => '???'

    op = Province.find_by_province_desc 'Unknown'
    op.country_id = oc.id
    op.save!
  end

  def self.down
    oc = Country.find_by_country_desc 'Other'
    oc.destroy if oc
    
    op = Province.find_by_province_desc 'Unknown'
    op.country_id = nil
    op.save!
  end
end

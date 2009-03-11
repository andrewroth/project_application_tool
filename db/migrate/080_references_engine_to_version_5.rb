class ReferencesEngineToVersion5 < ActiveRecord::Migration
  def self.up
    Rails.plugins["references_engine"].migrate(5)

    # the type column on each reference_instance has to be set to ApplnReference
    ReferenceInstance.find(:all).each do |r|
      r[:type] = 'ApplnReference'
      r.save!
    end
  end

  def self.down
    Rails.plugins["references_engine"].migrate(3)
  end
end

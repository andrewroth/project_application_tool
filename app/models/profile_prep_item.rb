class ProfilePrepItem < ActiveRecord::Base
  belongs_to :prep_item
  belongs_to :profile
end

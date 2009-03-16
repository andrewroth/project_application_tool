class ProfileTravelSegment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :travel_segment
  
  acts_as_list
end

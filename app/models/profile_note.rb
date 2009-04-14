class ProfileNote < ActiveRecord::Base
  belongs_to :profile
  belongs_to :creator, :class_name => 'Viewer'
end

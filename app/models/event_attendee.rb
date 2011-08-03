class EventAttendee < ActiveRecord::Base
  load_mappings
  include Common::Core::EventAttendee
  include Common::Core::Ca::EventAttendee
end

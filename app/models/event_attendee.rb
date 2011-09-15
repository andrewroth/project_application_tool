class EventAttendee < ActiveRecord::Base
  load_mappings
  include Common::Core::EventAttendee
end


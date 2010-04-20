# Question: Is this why address is an object seperate to a person, so they
# can own multiple addresses?
class EmergencyAddress < Address
  load_mappings
  include Common::Core::EmergencyAddress
end

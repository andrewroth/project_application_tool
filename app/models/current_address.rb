# Addresses are stored seperately to a person
# Question: Why?
class CurrentAddress < Address
  load_mappings
  include Common::Core::CurrentAddress
end

# Uses person_id, start_date, end_date, ministry_id, ministry_role_id
#
# The ministry_role should always be a StaffRole
class StaffInvolvementHistory < InvolvementHistory
  load_mappings
end

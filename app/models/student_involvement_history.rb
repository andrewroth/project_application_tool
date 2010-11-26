# uses person_id, start_date, end_date and campus_id and ministry_role,
# which should always be a StudentRole.
class StudentInvolvementHistory < InvolvementHistory
  load_mappings
end

class Assignmentstatus < CimHrdb
  set_primary_key "assignmentstatus_id"

  def self.campus_student_ids
    @@current_student ||= Assignmentstatus.find_all_by_assignmentstatus_desc('Current Student').first
    @@unknown ||= Assignmentstatus.find_all_by_assignmentstatus_desc('Unknown Status').first

    [ @@current_student, @@unknown ].compact.collect(&:id)
  end
end

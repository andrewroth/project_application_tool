class Assignmentstatus < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::Assignmentstatus

  def self.campus_student_ids
    @@current_student ||= Assignmentstatus.find_all_by_assignmentstatus_desc('Current Student').first
    @@unknown ||= Assignmentstatus.find_all_by_assignmentstatus_desc('Unknown Status').first

    [ @@current_student, @@unknown ].compact.collect(&:id)
  end

end

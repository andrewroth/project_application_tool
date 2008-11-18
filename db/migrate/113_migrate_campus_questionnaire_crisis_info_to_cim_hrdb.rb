class MigrateCampusQuestionnaireCrisisInfoToCimHrdb < ActiveRecord::Migration

  def self.down
  end

def self.loop_answers_for_element(id)
  e = Element.find id # current address valid until
  cnt = 0
  for a in e.answers
    next if a.answer.empty? || a.answer == 'unknown'

    app = Appln.find a.instance_id
    viewer = app.profile.viewer
    person = viewer.person
    emerg = person.emerg

    cnt += 1
    yield a, app, viewer, person, emerg
  end
  cnt
end

  def self.up

# local address valid until
printf "Converting local address valid until to cim_hrdb ("
cnt = loop_answers_for_element(17579) { |a, app, viewer, person, emerg|
  person.local_valid_until = Date.parse(a.answer)
  person.save!
}
puts "#{cnt})"

# local province
printf "Converting health care province to cim_hrdb ("
cnt = loop_answers_for_element(18460) { |a, app, viewer, person, emerg|
  p = Province.find_by_province_desc a.answer
  p = Province.find_by_province_shortDesc(a.answer) unless p
  emerg.health_province_id = p.id
  emerg.save!
}
puts "#{cnt})"

# health care #
printf "Converting health care number to cim_hrdb ("
cnt = loop_answers_for_element(18461) { |a, app, viewer, person, emerg|
  emerg.health_number = a.answer
  emerg.save!
}
puts "#{cnt})"

# blood type
printf "Converting blood type to cim_hrdb ("
cnt = loop_answers_for_element(18463) { |a, app, viewer, person, emerg|
  emerg.blood_type = a.answer
  emerg.save!
}
puts "#{cnt})"

# dentist's name
printf "Converting dentist's name ("
cnt = loop_answers_for_element(18464) { |a, app, viewer, person, emerg|
  emerg.dentist_name = a.answer
  emerg.save!
}
puts "#{cnt})"

# dentist's phone number
printf "Converting dentist's phone number ("
cnt = loop_answers_for_element(18465) { |a, app, viewer, person, emerg|
  emerg.dentist_phone = a.answer
  emerg.save!
}
puts "#{cnt})"

# doctor's name
printf "Converting doctor's name ("
cnt = loop_answers_for_element(18466) { |a, app, viewer, person, emerg|
  emerg.doctor_name = a.answer
  emerg.save!
}
puts "#{cnt})"

# doctor's phone number
printf "Converting doctor's phone number ("
cnt = loop_answers_for_element(18467) { |a, app, viewer, person, emerg|
  emerg.doctor_phone = a.answer
  emerg.save!
}
puts "#{cnt})"

p = Person.find 7307
p.province_id = Province.find_by_province_shortDesc('CO').id
p.save!

# DELETE  Current address valid until
e = Element.find 17579
e.page_elements.first.destroy

# DELETE  Provincial/State Medical Insurance 
a = Answer.find 336315
if a && a.answer = 'Plot 34253, Block 8'
  p = Person.find 8296
  p.person_addr += ", #{a.answer}" if p.person_addr == "380 Assiniboine Rd (apt 1802)"
  p.save!
end

# DELETE  Blood Type etc.. group
e = Element.find 18458
e.page_elements.first.destroy
e = Element.find 18462
e.page_elements.first.destroy

# DELETE  Permanent Address Additional Information
e = Element.find 17592
e.page_elements.first.destroy

  end
end


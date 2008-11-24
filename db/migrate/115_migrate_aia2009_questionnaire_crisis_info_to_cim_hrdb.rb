class MigrateAia2009QuestionnaireCrisisInfoToCimHrdb < ActiveRecord::Migration

  def self.loop_answers_for_element(id)
    e = Element.find_by_id id # current address valid until
    return unless e
    cnt = 0
    for a in e.answers
      next if a.answer.empty? || a.answer == 'unknown'
  
      app = Appln.find a.instance_id
      viewer = app.profile.viewer
      person = viewer.person
      emerg = person.emerg
    
      cnt += 1
      #puts a.answer
      yield a, app, viewer, person, emerg
    end
    cnt
  end
    
  def self.delete_element(id)
    begin
      e = Element.find id
      puts "delete #{e.text[0,20]}"
      e.destroy
    rescue
    end
  end
    
  def self.up
    # local address valid until
    printf "Converting AIA 2009 soccer tour - address valid until to cim_hrdb ("
    cnt = loop_answers_for_element(18446) { |a, app, viewer, person, emerg|
      a.answer = 'Jan 2010' if a.answer == '2010' # fix one
      begin
        person.local_valid_until = Date.parse(a.answer)
        person.save!
      rescue
        #puts "Couldn't parse '#{a.answer}'"
      end
    }
    puts "#{cnt})"
    
    # local province
    printf "Converting health care province to cim_hrdb ("
    cnt = loop_answers_for_element(18011) { |a, app, viewer, person, emerg|
      p = Province.find_by_province_desc a.answer
      p = Province.find_by_province_shortDesc(a.answer) unless p
      #puts "province: [#{a.answer}]" unless p
      if p
        emerg.health_province_id = p.id
        emerg.save!
      end
    }
    puts "#{cnt})"
    
    # health care #
    printf "Converting health care number to cim_hrdb ("
    cnt = loop_answers_for_element(18010) { |a, app, viewer, person, emerg|
      emerg.health_number = a.answer
      emerg.save!
    }
    puts "#{cnt})"
    
    # health care extended medical insurance
    printf "Converting health care extended to cim_hrdb ("
    cnt = loop_answers_for_element(18012) { |a, app, viewer, person, emerg|
      emerg.medical_plan_number = a.answer
      emerg.save!
    }
    puts "#{cnt})"
    
    # dentist's name
    printf "Converting doctor's name ("
    cnt = loop_answers_for_element(17997) { |a, app, viewer, person, emerg|
      emerg.doctor_name = a.answer
      emerg.save!
    }
    puts "#{cnt})"
    
    # dentist's phone number
    printf "Converting doctor's phone number ("
    cnt = loop_answers_for_element(17998) { |a, app, viewer, person, emerg|
      emerg.doctor_phone = a.answer
      emerg.save!
    }
    puts "#{cnt})"
    
    # doctor's name
    printf "Converting dentist's name ("
    cnt = loop_answers_for_element(17999) { |a, app, viewer, person, emerg|
      emerg.dentist_name = a.answer
      emerg.save!
    }
    puts "#{cnt})"
    
    # doctor's phone number
    printf "Converting dentist's phone number ("
    cnt = loop_answers_for_element(18000) { |a, app, viewer, person, emerg|
      emerg.dentist_phone = a.answer
      emerg.save!
    }
    puts "#{cnt})"
    
    # DELETE  doctor/dentist elements group
    delete_element 17995
    
    # DELETE  Current address valid until
    delete_element 18446
    
    # DELETE  Provincial/State Medical Insurance 
    delete_element 18010 # medical insurance
    delete_element 18011 # province / state
    delete_element 18012 # extended medical plan
  end

  def self.down
  end
end

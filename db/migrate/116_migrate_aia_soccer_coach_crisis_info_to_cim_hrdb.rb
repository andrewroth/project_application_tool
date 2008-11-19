class MigrateAiaSoccerCoachCrisisInfoToCimHrdb < ActiveRecord::Migration

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
    # local province
    printf "Converting health care province to cim_hrdb ("
    cnt = loop_answers_for_element(18554) { |a, app, viewer, person, emerg|
      p = Province.find_by_province_desc a.answer
      p = Province.find_by_province_shortDesc(a.answer) unless p
      if p
        emerg.health_province_id = p.id
        emerg.save!
      end
    }
    puts "#{cnt})"
    
    # health care #
    printf "Converting health care number to cim_hrdb ("
    cnt = loop_answers_for_element(18553) { |a, app, viewer, person, emerg|
      emerg.health_number = a.answer
      emerg.save!
    }
    puts "#{cnt})"
    
    # health care extended medical insurance
    printf "Converting health care extended to cim_hrdb ("
    cnt = loop_answers_for_element(18555) { |a, app, viewer, person, emerg|
      emerg.medical_plan_number = a.answer
      emerg.save!
    }
    puts "#{cnt})"
    
    # DELETE  # Medical Insurance: group
    delete_element 18551
  end
end


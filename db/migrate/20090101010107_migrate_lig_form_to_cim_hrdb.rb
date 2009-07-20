class MigrateLigFormToCimHrdb < ActiveRecord::Migration
  def self.down
  end

  def self.up
    convert 1359, :person, :person_legal_fname
    convert(1360) do |a,p,e| 
      next if ["n/a", "don't have one", "-", " ", "", "No middle name", "42" ].include? a
      next if a.empty?
      p.person_legal_fname += " #{a}";
      p.save!
    end
    convert 1361, :person, :person_legal_lname
    
    # gender
    begin
      genders = Hash[*['Male','Female','???'].collect{ |w| [ w, Gender.find_by_gender_desc(w).id ] }.flatten ]
      convert(1707) do |a,p,e|
        p.gender_id = genders[a]
      end
    rescue
    end
    
    # birthdate
    convert_date(1362, :emerg, :emerg_birthdate, false)
    convert_date(1369, :person, :local_valid_until, false)
    
    # local address line & additional info line
    convert 1370, :person, :person_local_addr, false
    convert(1371) do |a,p,e| 
      next if a.empty?
      p.person_local_addr += ", #{a}";
      p.save!
    end
    
    convert 1372, :person, :person_local_city, false
    convert_province(1373, :person, :person_local_province_id, false)
    convert_province(1374, :person, :person_local_province_id, false)
    convert 1375, :person, :person_local_pc, false
    convert 1376, :person, :person_local_phone, false
    convert 1377, :person, :cell_phone, false
    
    # permanent address
    # address line & additional info line
    convert 1382, :person, :person_local_addr, false
    convert(1383) do |a,p,e| 
      next if a.empty?
      p.person_local_addr += ", #{a}";
      p.save!
    end
    
    convert 1384, :person, :person_local_city, false
    convert_province(1385, :person, :person_local_province_id, false)
    convert_province(1386, :person, :person_local_province_id, false)
    convert 1387, :person, :person_local_pc, false
    convert 1388, :person, :person_local_phone, false
    
    convert(1381) do |a,p,e|
      if a == '1'
        copy_local_to_perm p, 'addr'
        copy_local_to_perm p, 'city'
        copy_local_to_perm p, 'pc'
        copy_local_to_perm p, 'phone'
        p.province_id = p.person_local_province_id
        p.save!
      end
    end
    
    # crisis info
    # ec1
    
    crisis_contact 1398, 'emerg_contact'
    crisis_contact 1406, 'emerg_contact2'
    
    # medical professionals
    convert 1414, :emerg, :doctor_name, false
    convert 1415, :emerg, :doctor_phone, false
    convert 1416, :emerg, :dentist_name, false
    convert 1417, :emerg, :dentist_phone, false
    
    # medical conditions
    convert 1421, :emerg, :emerg_medicalNotes, false
    convert 1422, :emerg, :emerg_meds, false
    
    # medical insurance
    convert 1427, :emerg, :health_number, false
    convert_province 1428, :emerg, :health_province_id, false
    convert_province 1429, :emerg, :medical_plan_number, false
    
    # passport
    convert 1435, :emerg, :emerg_passportNum, false
    convert 1434, :emerg, :emerg_passportOrigin, false
    convert_date 1436, :emerg, :emerg_passportExpiry, false
    
    page_id = 98
    begin    
       unless Page.find(page_id) && Page.find(page_id).elements.find_by_text("Personal Info Form")
        puts "create personal info element"
        e = PersonalInformation.create :text => "Personal Info Form"
        e.page_elements.create :page_id => page_id, :element_id => e.id, :position => 1
      else
        puts "personal info element already found"
      end
    rescue
    end
    delete_element 1358 # instruction
    delete_element 1359 # first
    delete_element 1360 # middle
    delete_element 1361 # last
    delete_element 1707 # sex
    delete_element 1362 # birthdate
    # leave in married status, spouse name
    delete_element 1368 # current 
    delete_element 1369 # valid until 
    delete_element 1370 # street address
    delete_element 1371 # additional address info
    delete_element 1372 # city
    delete_element 1373 # province
    delete_element 1374 # province for non-cdn res
    delete_element 1375 # postal code
    delete_element 1376 # home tel
    delete_element 1377 # cell
    delete_element 1378 # email
    # leave in frequency check email
    delete_element 1380 # perm
    delete_element 1381 # same as?
    delete_element 1382 # street address
    delete_element 1383 # street address 2
    delete_element 1384 # city
    delete_element 1385 # province
    delete_element 1386 # province non-cdn res
    delete_element 1387 # pc
    delete_element 1388 # tel
    
    # that's it for personal info, on to emergency contact
    page_id = 100
    begin
      unless e = Page.find(page_id).elements.find_by_text("Emergency Contact Form")
        puts "create emergency contact info element"
        e = CrisisInformation.create :text => "Emergency Contact Form"
        e.page_elements.create :page_id => page_id, :element_id => e.id, :position => 1
      else
        puts "emergency contact info element already found"
      end
    rescue
    end

    delete_element 1396 # ec1
    delete_element 1404 # ec2
    delete_element 1412 # medical professionals
    delete_element 1418 # medical conditions
    delete_element 1425 # medical infsurance
    
    delete_element 1432 # passport header
    delete_element 1433 # passport q
    delete_element 1434 # passport country
    delete_element 1435 # passport number
    delete_element 1436 # passport expiry
    
    # rename expiry q
    e1 = Element.find_by_id 1393
    e2 = Element.find_by_id 1394
    e3 = Element.find_by_id 1395
    e4 = e
    e5 = Element.find_by_id 1431
    
    i = 0
    p = Page.find_by_id 100
    if p
      for e in [ e1, e2, e3, e4, e5 ].compact
        puts "reorder #{e.id}"
        pe = p.page_elements.find_by_element_id e.id
        if pe.nil? then puts "couldn't find #{e.id}" end
        pe.position = i
        pe.save!
    
        i += 1
      end
    end
  end

    def self.loop_answers_for_element(id)
      e = Element.find id # current address valid until
      cnt = 0
      for a in e.answers
        next if a.answer.empty? || a.answer == 'unknown'
    
        app = Appln.find_by_id a.instance_id
        next unless app
    
        viewer = app.profile.viewer
        person = viewer.person
        emerg = person.emerg
    
        cnt += 1
        yield a, app, viewer, person, emerg
      end
      cnt
    end
    
    def self.convert(id, model = nil, att = nil, debug = false)
      begin
        e = Element.find id
      rescue
        puts "Couldn't find element #{id}"
        return
      end
    
      printf "Converting '#{e.text[0,50]}' -> #{model}.#{att} ("
      cnt = loop_answers_for_element(id) { |a, app, viewer, person, emerg|
        if model == :person || model == :emerg
         if model == :emerg && emerg.nil? then emerg = person.emerg end # make new ones
    
         subject = (model == :person ? person : emerg)
    
         attv = subject.send("#{att}")
         if attv.nil? || (attv.class == String && attv.empty?) || true
           if a.answer[a.answer.length-1,a.answer.length] == ' '
             a.answer = a.answer[0,a.answer.length-1]
           end
           puts("#{att}="+a.answer) if debug
           a.answer = yield(a.answer) if block_given?
           subject.send("#{att}=", a.answer)
           subject.save!
         end
        else yield a.answer, person, emerg
        end
      }
      puts "#{cnt})"
    end
    
    def self.convert_date(id,m,c,debug = nil)
      convert(id,m,c,debug) do |a|
        
        begin
          d = Date.parse(a)
          puts "#{a} => #{d}" if debug
          d
        rescue
          puts "Couldn't parse date #{a}" if debug
          nil
        end
      end
    end
    
    def self.convert_province(id,m,c,d = nil)
      convert(id,m,c,d) do |a|
        p = Province.find_by_province_desc a
        p = Province.find_by_province_shortDesc(a) unless p
        #puts "Can't find #{a}" unless p
        p = Province.find_by_province_desc('Unknown') if a == 'OT' || p.nil?
        p.id if p
      end
    end

    def self.convert_province(id,m,c,d = nil)
      convert(id,m,c,d) do |a|
        p = Province.find_by_province_desc a
        p = Province.find_by_province_shortDesc(a) unless p
        #puts "Can't find #{a}" unless p
        p = Province.find_by_province_desc('Unknown') if a == 'OT' || p.nil?
        p.id if p
      end
    end

    def self.copy_local_to_perm(p, c, debug = false)
      perm = p.send("person_#{c}")
      local = p.send("person_local_#{c}")
      if perm && !perm.empty?
        puts "Alrady have data in permanent #{c}: #{perm} (local=#{local})" if debug && perm != local
      else
        puts "Copy #{local}" if debug
        p.send("person_#{c}=", local)
      end
    end
    
    def self.crisis_contact(base, prefix)
      i = 0
      for suffix in [ 'Name', 'Rship', 'Home', 'Work', 'Mobile', 'Email' ]
        convert base + i, :emerg, :"#{prefix}#{suffix}"
        i += 1
      end
    end
  
    def self.delete_element(id)
      begin
        e = Element.find id
        puts "Destroying '#{e.text[0,50]}'"
        if e.parent_id
          e.parent_id = nil
          e.save!
        else
          e.page_elements.first.destroy unless e.page_elements.empty?
        end
      rescue
      end
    end
end

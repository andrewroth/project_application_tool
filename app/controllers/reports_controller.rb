require_dependency 'my_ordered_hash.rb'

class ReportsController < ApplicationController
  include TravelSegmentTagsAutocomplete
  
  before_filter :set_title
  before_filter :set_permissions_level
  before_filter :ensure_is_general_staff
  # they want all staff to be able to see everything..
  #before_filter :ensure_is_projects_coordinator, :except => [ :index, :cm, :crisis_management, :project_stats ]
  before_filter :set_projects, :only => [ :participants, :registrants, :crisis_management, :parental_emails, 
    :ticketing_requests, :funding_status, :funding_details, :viewers_with_profile_for_project,
    :funding_details_costing, :funding_details, :travel_list, :project_stats, :funding_costs,
    :itinerary, :interns, :summary_forms, :cost_items_for_project, :cost_items, :manual_donations, :prep_items, :prep_items_for_project ]
  before_filter :set_viewer, :only => [ :funding_details_costing, :funding_details, :funding_costs ]
  before_filter :set_travel_segment, :only => [ :travel_segment, :custom_itinerary ]
  before_filter :set_cost_items, :only => [ :cost_items ]
  before_filter :set_prep_items, :only => [ :prep_items ]
  before_filter :set_skip_title
  before_filter :try_to_delete_invalid_apps, :only => [ :project_stats ]
  
  def index
    projects = @eg.projects
    if @viewer.is_eventgroup_coordinator?(@eg)
      @project_with_full_view = projects
      @project_director_projects = projects
    else
      @project_with_full_view = []
      @project_director_projects = []
      projects.each do |p|
        @viewer.set_project p
        if @viewer.is_project_administrator? || @viewer.is_project_director?
          
          @project_with_full_view << p
          @project_director_projects << p
          
        elsif @viewer.is_project_staff?
          @project_with_full_view << p
        end
      end
    end
    
    @project_with_full_view.sort! { |a,b| a.title <=> b.title }
  end
  
  def pdf
    generator = IO.popen("htmldoc -t pdf --path \".;http://#{@request.env["HTTP_HOST"]}\" --webpage -", "w+")
    generator.puts @template.render("reports/pdf_test_content")
    generator.close_write

    send_data(generator.read, :filename => "test.pdf", :type => "application/pdf")
  end

  def mk_sel(s)
    for klass in [ Person, Campus, Assignment, YearInSchool, Project, Profile ]
      s.gsub!(klass.name, klass.table_name)
    end
    logger.info s
    s
  end

  Registrant = Struct.new(:last_name, :first_name, :gender, :campus, :year, :status, :pref1, :pref2, :accepted, :phone, :email)
  def registrants
    @columns = MyOrderedHash.new( [
      :last_name, 'string',
      :first_name, 'string',
      :gender, 'string',
      @eg.has_your_campuses ? [ :campus, 'string' ] : nil,
      @eg.has_your_campuses ? [ :year, 'int' ] : nil,
      :status, 'string',
      :pref1, 'string',
      :pref2, 'string',
      :accepted, 'string',
      :phone, 'string',
      :email, 'string'
    ].flatten.compact )
    @rows = [ ]

    @page_title = (@many_projects ? @eg.title : @project_title) + " Registrants"

    # this is gonna be awesome
    applns = Appln.find_all_by_preference1_id(@projects_ids, :include =>
      [ :preference1, :preference2,
        { :profiles =>
          [ :project,
            { :viewer =>
              { :persons =>
                { :person_years => :year_in_school, :assignments => :campus
                }
              }
            }
          ]
        }
      ],
      :select => mk_sel("Person.person_lname, Person.person_fname, Person.gender_id, Campus.campus_shortDesc, Assignment.assignmentstatus_id, YearInSchool.year_desc, Project.title, Profile.status, Profile.type, Person.person_local_phone, Person.person_email")
    )

    #@rows = [ [  ] ]
    @rows = applns.collect{ |appln|
      profile = appln.profile
      viewer = appln.profile.viewer
      person = viewer.person

      [
        person.person_lname,
        person.person_fname,
        person.gender,
        @eg.has_your_campuses ? person.campus_shortDesc(:search_arrays => true) : :skip,
        @eg.has_your_campuses ? person.year_in_school.year_desc : :skip,
        profile.status,
        appln.preference1.title,
        (appln.preference2.title if appln.preference2),
        if profile.class == Acceptance then profile.project.title end,
        person.person_local_phone,
        person.person_email
      ].delete_if{ |i| i == :skip }
    }

    render_report @rows
  end
  
  def participants
    @columns = MyOrderedHash.new( [
      :last_name, 'string',
      :first_name, 'string',
      :gender, 'string',
      :project, 'string',
      @eg.has_your_campuses ? [ :campus, 'string' ] : nil,
      @eg.has_your_campuses ? [ :year, 'int' ] : nil,
      :phone, 'string',
      :cell, 'string',
      :email, 'string'
    ].flatten.compact )
    @rows = [ ]

    @page_title = @projects.collect(&:title).join(', ') + " Participants"

    acceptances = Acceptance.find_all_by_project_id(@projects_ids, :include => [
            :project,
          { :viewer =>
            { :persons =>
              { :person_years => :year_in_school, :assignments => :campus
              }
            }
          }
      ],
      :select => mk_sel("Person.person_lname, Person.person_fname, Person.gender_id, Campus.campus_shortDesc, Assignment.assignmentstatus_id, YearInSchool.year_desc, Project.title, Profile.status, Profile.type, Person.person_local_phone, Person.cell_phone, Person.person_email")
    )

    #@rows = [ [  ] ]
    @rows = acceptances.collect{ |acceptance|
      viewer = acceptance.viewer
      person = viewer.person

      [
        person.person_lname,
        person.person_fname,
        person.gender,
        acceptance.project.title,
        @eg.has_your_campuses ? person.campus_shortDesc(:search_arrays => true) : :skip,
        @eg.has_your_campuses ? person.year_in_school.year_desc : :skip,
        person.person_local_phone,
        person.cell_phone,
        person.person_email
      ].delete_if{ |i| i == :skip }
    }

    render_report @rows
  end
 
  def project_participants_old
    @columns = MyOrderedHash.new [
    :last_name, 'string', 
    :first_name, 'string',
    :gender, 'string',
    :email, 'string',
    :phone, 'string',
    :cell, 'string',
    :campus, 'string',
    :year, 'int',
    :project, 'string',
    :leadership, 'string',
    :training, 'string',
    :intern, 'string'
    ]
    
    #    current_acceptances = Acceptance.find_by_sql("select appln_id, viewer_id, project_id, `year` from acceptances ac, applns ap, forms f " + 
    #                          "where ac.appln_id = ap.id and ap.form_id = f.id and f.year = #{$year} and project_id in (#{@projects_ids.join(',')})")
    @participants = []
    #    current_acceptances.each do |ac|
    loop_reports_viewers(@projects_ids, @include_pref1_applns) do |ac,a,v,p|
      
      if !v.is_student?(@eg) || p.nil?
        next
      end
      pf = a.processor_form
      
      leadership = extract_form_answer(:leadership_rating, pf)
      training = extract_form_answer(:training_rating, pf)
      phone = extract_form_answer(:phone, a)
      cell = extract_form_answer(:cell, a)
      
      gender = p.gender
      
      @participants << ProjectParticipant.new(
        p.person_lname, p.person_fname, gender, p.person_email, phone, cell, (p.campus ? p.campus_shortDesc : ''), 
        extract_form_answer(:campus_year, a), ac.project.title, leadership, training,
        (ac && ac.as_intern? ? 'intern' : '')
      )
      
      false # send a false back since we use our own participants list
    end
    @page_title = "#{@eg.title} #{@project_title} Participants"
    render_report @participants
  end
  
  CMRegistrant = Struct.new(:reg, :with_group, :plans)
  def cm
    # apparently everyone should be able to see everyone's cm 2007 plans...
    @projects = @eg.projects
    @projects_ids = @projects.collect{ |p| p.id }
    
    @cm_registrants = []
    registrants_only do |v, a, registrant|
      if !a.nil? && extract_form_answer(:attending_cm, a) == "Yes"
        @cm_registrants << CMRegistrant.new(registrant, extract_form_answer(:cm_travel_with_group, a), extract_form_answer(:cm_plans, a))
      end
    end
    @columns[:with_group] = 'string'
    @columns[:plans] = 'string'
    @default_sort = :pref1
    
    @page_title = "#{@eg.title} CM -- Registrants who are going to CM 2007."
    render_report @cm_registrants
  end
  
  def ticketing_requests
    @columns = MyOrderedHash.new [
    :last_name, 'string', 
    :first_name, 'string',
    :legal_name, 'string',
    :gender, 'string',
    :staff, 'string',
    @include_pref1_applns ? [ :status, 'string' ] : nil,
    :project, 'string',
    :birthdate, 'string',
    :departure_city, 'string',
    :passport_number, 'string',
    :passport_country, 'string',
    :passport_expiry, 'int',
    :cm2007, 'string',
    :intern, 'string',
    :notes, 'string'
    ].compact.flatten
    
    @participants = []
    
    loop_reports_viewers(@projects_ids, @include_pref1_applns, true) do |ac,a,v,p|
      
      if v.is_student?(@eg)
        departure = extract_form_answer(:departure_city, a)
        other = extract_form_answer(:departure_other, a)
        if other =~ /\S/ then departure += " other: " + other end
        legal_name = extract_form_answer(:first_name, a) + " " + extract_form_answer(:middle_name, a) + " " + extract_form_answer(:last_name, a)
        birthdate = extract_form_answer(:birthdate, a)
        passport_number = extract_form_answer(:passport_number, a)
        passport_country = extract_form_answer(:passport_country_origin, a)
        passport_expiry = extract_form_answer(:passport_expiry, a)
        cm2007 = (extract_form_answer(:attending_cm, a) == "Yes" ? 'cm2007' : '')
        notes = extract_form_answer(:travel_request_notes, a)
      else
        departure = ''
        other = ''
        legal_name = v.name
        ec_entry = p.emerg
        birthdate = ec_entry ? ec_entry.emerg_birthdate : ''
        passport_number = ''
        passport_country = ''
        passport_expiry = ''
        cm2007 = ''
        notes = ''
      end
      
      gender = p.gender
      
      @participants << [ p.person_lname.capitalize, p.person_fname.capitalize, legal_name, gender, v.is_student?(@eg) ? '' : 'staff',
        @include_pref1_applns ? (ac ? 'accepted' : a.status) : nil, ac ? ac.project.title : a.preference1.title, 
        birthdate, departure, passport_number, passport_country, passport_expiry, cm2007, 
        ((ac && ac.as_intern?) || (ac.nil? && a.as_intern?) ? 'intern' : ''), notes ].compact
    end
    
    @page_title = "#{@eg.title} #{@project_title} Ticketing Requests #{@include_pref1_applns ? ' plus pref1s' : ''}"
    render_report @participants
  end
  
  def itinerary
    @profiles = []
    @editors = "restricted"
    @page_title = "#{@eg.title} #{@project_title} Itinerary"
    @include_profiles = true.to_s
    
    loop_reports_viewers(@projects_ids, false, true) do |profile,a,v,person|
      name = if person then person.name elsif v then 
         v.viewer_userID else "? (profile id=#{profile.id})" end
      @profiles << [ name, profile.project, profile ]
    end

    render_report nil
  end

  def processor_forms
    redirect_to :controller => :projects, 
                :action => :bulk_processor_forms, 
                :id => params[:project_id],
                :view => 'print',
                :viewer_id => params[:viewer_id],
                :print => params[:format]
  end

  def summary_forms
    redirect_to :controller => :projects, 
                :action => :bulk_summary_forms, 
                :id => params[:project_id],
                :view => 'print',
                :viewer_id => params[:viewer_id],
                :print => params[:format]
  end
  
  def generate_cache(viewer_ids)
    viewer_ids << -100 # -100 as some bogus id so that the IN ( ) sql stmt doesn't give an error when empty
    viewer_ids.delete_if { |vid| vid.nil? || vid == '' }
    viewers = Viewer.find :all, :conditions => "accountadmin_viewer.viewer_id IN (#{viewer_ids.join(',')})", :include => :access
    viewers_cache = {}
    viewers.each { |v| viewers_cache[v.id] = v }
    
    person_ids = viewers.collect{|v| v.access.person_id }.compact
    persons = Person.find person_ids
    persons_cache = {}
    persons.each { |p| persons_cache[p.id] = p }
    
    [ viewers_cache, persons_cache ]
  end
  
  def make_answers_cache(instance_list)
    @@form_elements[@eg.id] ||= { :values => [] }
    return if @@form_elements[@eg.id][:values].nil? || @@form_elements[@eg.id][:values].empty?
    Answer.find_all_by_question_id_and_instance_id @@form_elements[@eg.id][:values].uniq, instance_list.collect{|ins| ins.id}
  end
  
  # lets me switch from the optimized one and old one quickly
  def loop_reports_viewers_switch(project_ids, include_pref1_applns = false)
    loop_reports_viewers(project_ids, include_pref1_applns) do |ac,a,v,p|
      yield ac,a,v,p
    end
  end
  
  def loop_reports_viewers_old(project_ids, include_pref1_applns = false)
    
    accepted = Acceptance.find_all_by_project_id(project_ids)
    accepted.each do |ac|      
      a = ac.appln
      v = a.viewer
      p = v.person
      
      yield ac,a,v,p
    end
    
    if include_pref1_applns
      # go through everyone who has pref 1
      pref1s = Appln.find_all_by_preference1_id(project_ids)
      pref1s.each do |a|
        next if a.acceptance
        v = a.viewer
        next if v.nil?
        p = v.person
        
        yield nil,a,v,p
      end
    end
  end
  
  # -loops through all viewers set by project_ids, calling yield
  # -special if include_pref1_applns is true it will
  #  loop through all viewers with an application with pref 1 set
  #  to a project in project_ids
  # -now optimized, to the detriment of readability, but it's from 30s -> 5s ???!?!?!?! is it??!?!
  #    because it does mass select statements instead of looping through each one
  def loop_reports_viewers(project_ids, include_pref1_applns = false, include_staff = false)
    accepted = Acceptance.find_all_by_project_id(project_ids, :include => [ :project, :appln ])
    viewer_ids = accepted.collect{ |ac| ac.appln.viewer_id }
    viewers_cache, persons_cache = generate_cache(viewer_ids)
    applns_list = Appln.find :all, :conditions => "viewer_id in (#{viewer_ids.join(',')})", :include => :processor_form_ref
    applns = {}
    applns_list.each do |a| applns[a.id] = a end
    
    accepted.sort!{ |a1, a2|
      v1 = viewers_cache[a1.viewer_id]
      v2 = viewers_cache[a2.viewer_id]
      p1 = persons_cache[v1.access.person_id]
      p2 = persons_cache[v2.access.person_id]
      p1.name <=> p2.name
    }

    accepted.each do |ac|
      a = applns[ac.appln_id]
      next if a.nil?
      v = viewers_cache[a.viewer_id]
      @answers_cache = make_answers_cache [ a, a.processor_form ]
      yield ac, a, v, persons_cache[v.access.person_id]
    end
    
    if include_pref1_applns
      # go through everyone who has pref 1
      pref1s = Appln.find_all_by_preference1_id(project_ids, :include => :preference1, :include => :processor_form_ref)
      pref1_ids = pref1s.collect{|a| a.id } << -100
      pref1s_acceptances_list = Acceptance.find :all, :conditions => "appln_id in (#{pref1_ids.join(',')})"
      pref1s_a_to_ac = {}
      pref1s_acceptances_list.each do |ac| pref1s_a_to_ac[ac.appln_id] = ac end
      viewers_cache, persons_cache = generate_cache(pref1s.collect{ |a| a.viewer_id })
      
      pref1s.each do |a|
        next if pref1s_a_to_ac[a.id]
        v = viewers_cache[a.viewer_id]
        next if v.nil?
        @answers_cache = make_answers_cache [ a, a.processor_form ]
        
        yield nil, a, v, persons_cache[v.access.person_id]
      end
    end
    
    if include_staff
      staff_profiles = StaffProfile.find_all_by_project_id(project_ids)
      viewers_cache, persons_cache = generate_cache(staff_profiles.collect{ |profile| profile.viewer_id })

      for staff_profile in staff_profiles
        v = viewers_cache[staff_profile.viewer_id]

	person = nil
	person = persons_cache[v.access.person_id] if v && v.access
	
        yield staff_profile, nil, v, person
      end
    end
  end
  
  EmergencyContact = Struct.new(:name, :relation, :home_number, :work_number, :cell_number, :email)
  PassportInfo = Struct.new(:number, :expiry, :country)
  EmergencyInfo = Struct.new(:cond, :meds)
  ProjectEmergencyParticipant = Struct.new(:last_name, :first_name, :project, :gender, :staff, :birthdate, :passport, 
                                           :emergency_info, :contact1, :contact2)
  HealthInfo = Struct.new(:number, :province)
  InsuranceInfo = Struct.new(:carrier, :number)
  DoctorsInfo = Struct.new(:doctors_name, :doctors_phone, :dentist_name, :dentist_phone)
  def crisis_management
    
    @columns = MyOrderedHash.new [
    :last_name, 'string', 
    :first_name, 'string',
    @many_projects ? [ :project, 'string' ] : nil,
    :gender, 'string',
    :staff, 'string', 
    :curr_prov, 'string',
    :perm_prov, 'string',
    :birthdate, 'string',
    :passport_number, 'string',
    :passport_expiry, 'int',
    :passport_country, 'string',
    :have_conditions, 'string',
    :have_meds, 'string',
   ].compact.flatten
    @columns.merge! emergency_contact_columns('c1_')
    @columns.merge! emergency_contact_columns('c2_')
    @columns.merge! MyOrderedHash.new([
    :health_number, 'string',
    :health_province, 'string',
    :ins_carrier, 'string',
    :ins_number, 'string',
    :doc_name, 'string',
    :doc_phone, 'string',
    :dentist_name, 'string',
    :dentist_phone, 'string'
    ])
 

    # index where the sub objects are so they can be referenced directly in the partial
    pp_pos = @columns.position(:passport_number)
    @index = { :passport => pp_pos, :emerg => pp_pos+1, :c1 => pp_pos+2, :c2 => pp_pos+3, 
               :hinfo => pp_pos+4, :hins => pp_pos+5, :doctors => pp_pos+6 }

    @registrants = []
    
    loop_reports_viewers(@projects_ids, @include_pref1_applns, true) do |ac,a,v,p|
      
      gender = p.gender

      ec_entry = nil # used in get_passport_info
      ec_entry = p.emerg

      empty_wc = EmergencyContact.new('','','','','','')

      emergency_contact_1 = EmergencyContact.new(ec_entry.emerg_contactName,
                              ec_entry.emerg_contactRship,
                              ec_entry.emerg_contactHome,
                              ec_entry.emerg_contactWork,
                              ec_entry.emerg_contactMobile,
                              ec_entry.emerg_contactEmail)

      emergency_contact_2 = EmergencyContact.new(ec_entry.emerg_contact2Name,
                              ec_entry.emerg_contact2Rship,
                              ec_entry.emerg_contact2Home,
                              ec_entry.emerg_contact2Work,
                              ec_entry.emerg_contact2Mobile,
                              ec_entry.emerg_contact2Email)

      emergency_info = EmergencyInfo.new(ec_entry.emerg_medicalNotes, ec_entry.emerg_meds)

      birthdate = ec_entry ? ec_entry.emerg_birthdate : ''
      birthdate = birthdate.to_s # might be nil

      passport_info = get_passport_info(ac, p, a, ec_entry)
      
      hp = ec_entry.health_province ? ec_entry.health_province.province_shortDesc : ''
      health_info = HealthInfo.new(ec_entry.health_number, hp)
      ins_info = InsuranceInfo.new(ec_entry.medical_plan_carrier, ec_entry.medical_plan_number)
      doc_info = DoctorsInfo.new(ec_entry.doctor_name.to_s, ec_entry.doctor_phone.to_s,
                                 ec_entry.dentist_name.to_s, ec_entry.dentist_phone.to_s) 

      @registrants << [ p.person_lname.capitalize, p.person_fname.capitalize, @many_projects ? ac.project.title : nil, gender,
        v.is_student?(@eg) ? '' : 'staff', 
        (p && p.loc_province ? p.loc_province.province_shortDesc : ''),
        (p && p.perm_province ? p.perm_province.province_shortDesc : ''),
        birthdate, passport_info,
        emergency_info, emergency_contact_1, emergency_contact_2,
        health_info, ins_info, doc_info ].compact
    end
 
    @page_title = "#{@eg.title} #{@project_title} Crisis Management Report"
    render_report @registrants
  end
  
  StatEntry = Struct.new(:project, :started, :submitted, :completed, :accepted, :total, :declined, :withdrawn)
  def project_stats
    
    @columns = MyOrderedHash.new [
    :project, 'string', 
    :started, 'int',
    :submitted, 'int',
    :completed, 'int',
    :accepted, 'int',
    :total_first_4, 'int',
    :declined, 'int',
    :withdrawn, 'int'
    ]
    
    # special case for people assigned to the regional/national campus
    # they can see everything
    if @viewer.person && @viewer.person.campuses.find_by_campus_shortDesc('Reg/Nat')
      @projects = @eg.projects
    end

    @stats = []
    totals = {}
    @projects.each do |p|
      stat = StatEntry.new(p.title,

      Applying.find_all_by_status_and_project_id('started', p.id).size,
      
      Applying.find_all_by_project_id_and_status(p.id, 'submitted').size,
      
      Applying.find_all_by_project_id_and_status(p.id, 'completed').size,
      
      Acceptance.find_all_by_project_id(p.id).size,
      nil,
      Withdrawn.find_all_by_status_and_project_id('declined', p.id).size,
      Withdrawn.find_all_by_status_and_project_id(['self_withdrawn','admin_withdrawn'], p.id).size)
      
      # set total for first 4 columns
      stat[:total] = stat[:started] + stat[:submitted] + stat[:completed] + stat[:accepted]
      
      @stats << stat
      
      StatEntry.members.each do |m|
        next if m == 'project'
        ms = :"#{m}"
        totals[ms] = 0 if !totals[ms]
        totals[ms] += stat[ms]
      end
    end
    @stats << StatEntry.new('', totals[:started].to_s, 
    totals[:submitted].to_s, totals[:completed].to_s, 
    totals[:accepted].to_s, totals[:total].to_s, totals[:declined].to_s, totals[:withdrawn].to_s) if @many_projects
    @page_title = "#{@eg.title} #{@project_title} Summer Stats"
    render_report @stats
  end
  
  ParticipantAndParent = Struct.new(:first, :last, :gender, :parent)
  def parental_emails
    
    @columns = MyOrderedHash.new [
    :participant_first_name, 'string', 
    :participant_last_name, 'string',
    :participant_gender, 'string',
    :staff, 'string', 
    ]
    @columns[:project] = 'string' if @many_projects
    @columns.merge! emergency_contact_columns('contact_')
    
    @participants = []
    
    loop_reports_viewers(@projects_ids, @include_pref1_applns, true) do |ac,a,v,p|
      
#      a = ac.appln
#      v = a.viewer
#      p = v.person
      
      if ac.class == Acceptance
        ec = emergency_contact(1, a)
      elsif ac.class == StaffProfile
        ec_entry = p.emerg
        empty_wc = EmergencyContact.new('','','','','','')
        ec = if ec_entry
          EmergencyContact.new(ec_entry.emerg_contactName,
                               ec_entry.emerg_contactRship,
                               ec_entry.emerg_contactHome,
                               ec_entry.emerg_contactWork,
                               ec_entry.emerg_contactMobile,
                               ec_entry.emerg_contactEmail)
        else
          empty_wc
        end
      end
      
      gender = p.gender
      
      @participants << [ p.person_lname.capitalize, p.person_fname.capitalize, gender, v.is_student?(@eg) ? '' : 'staff', @many_projects ? ac.project.title : nil, ec ].compact
    end
        
    @page_title = "#{@eg.title} #{@project_title} Parental Emails"
    render_report @participants
  end
  
  def funding_status()
    @columns = MyOrderedHash.new [
    :name, 'string', 
    :gender, 'string',
    :staff, 'string',
    @many_projects ? [ :project, 'string' ] : nil,
    :received, 'currency',
    :claimed, 'currency',
    :target, 'currency',
    :outstanding, 'currency',
    :amount_to_raise, 'currency',
    ].flatten.compact
    
    @participants = []
    totals = {}
    
    loop_reports_viewers(@projects_ids, @include_pref1_applns, true) do |ac,a,v,p|
      
      next if v.nil?

      participant = funding_details_for_participant(ac, v, p)
      @participants << participant
      
      c_i = 0
      @columns.each_pair do |c,t|
        if t == 'currency'
          totals[c] ||= 0.0
          totals[c] += participant[c_i].to_f
        end
        c_i += 1
      end
    end
    
    totals[:name] = '' # clear name
    totals[:project] = '' if @many_projects # clear project
    @participants << @columns.collect{ |pair| totals[pair[0]] }
    
    @page_title = "#{@eg.title} #{@project_title} Funding Status Report"
    render_report @participants
  end
  
  def funding_details_for_participant(ac, v, p)
    received = 0
    claimed = 0
    target = 0

    received = ac.donations_total
    target = ac.funding_target(@eg)
    claimed = ac.support_claimed.to_f.to_s

    gender = if p then p.gender else 'unknown' end
    staff = if v.nil? then 'missing viewer' elsif v.is_student?(@eg) then '' else 'staff' end 
     
    participant = [ p ? p.name : 'unknown' , gender, staff, (@many_projects ? ac.project.title : nil),
    received, claimed, target, target - received, target - claimed.to_f ].compact
  end

  def funding_details_costing
    render :inline => render_component_as_string(:action => 'funding_details', :params => params) + "\r\n\r\n" + 
    render_component_as_string(:action => 'funding_costs', :params => params)
  end
  
  def funding_details
    # find profile 
    profiles = Profile.find_all_by_project_id_and_viewer_id @projects.collect { |p| p.id }, @report_viewer.id
    profile = profiles[0] # uh take the first one if there are multiple projects requested
    
    if profile.nil?
      flash[:notice] = "Couldn\'t find a profile for #{@report_viewer.name}."
      @rows = []
      return
    end
    
    # got a profile , now print all the donations that have come in for that acceptance
    columns = [ 'donor_name',
      [ 'donation_type', 'type' ], 
      [ 'donation_reference_number', 'reference' ], 
      [ 'donation_date', 'date'] , 
      [ 'original_amount', 'orig_amount' ],
      [ 'amount', 'amount' ],
      [ 'conversion_rate', 'conv_rate' ],
      'status'
    ]

    @columns = columns_from_model AutoDonation, columns # used for client-side javascript sorting
    @columns['orig_amount'] = 'currency'
    @columns['conv_rate'] = 'currency'
    @columns['amount'] = 'currency'
    @columns['status'] = 'string' # for manual donations
    
    @rows = get_rows(profile.donations, columns)
    
    # fix status since get_rows uses model[attribute] which bypasses
    # the code that removes status for non-USDMANUAL donations
    status_column = columns.index 'status'
    profile.donations.each_with_index do |d,i|
      @rows[i][status_column] = d.status if d.respond_to?(:status)
    end

    # some totals at the bottom
    @rows << [ 'total', '', '', '', profile.donations_total(:orig => true), profile.donations_total ]
    
    @page_title = "#{@eg.title} #{@project_title} #{@report_viewer.name} Funding Details Report"
    render_report @rows
  end
  
  def funding_costs_rows
    @columns = MyOrderedHash.new [
        'type', 'string',
        'amount', 'currency',
    ]
    
    # grab the first profile found if multiple projects were passed
    profiles = Profile.find_all_by_viewer_id_and_project_id @report_viewer.id, 
                  @projects.collect{|p| p.id}, :include => :optin_cost_items
    profile = profiles[0]
    
    total, *types = profile.costing(@eg)
    
    @rows = []
    types.each { |type| 
      @rows << [ type[:name], nil ]
      type[:items].each do |item|
        @rows << [ item.description, item.amount ]
      end
    }
    
    total = profile.donations_total
    target = profile.funding_target(@eg)
    
    @rows << [ 'total', total ]
    @rows << [ 'target', target ]
    @rows << [ 'shortfall', target - total ]
  end
  
  def funding_costs
    funding_costs_rows
    @page_title = "#{@eg.title} #{@project_title} #{@report_viewer.name} Funding Costs"
    render_report @rows, :sortable => false
  end
  
  def project_paperwork
  end
  
  def travel_list
    @columns = MyOrderedHash.new [
    :title, 'string',
    :last_name, 'string', 
    :first_name, 'string',
    @include_pref1_applns ? [ :status, 'string' ] : nil,
    @many_projects ? [ :project, 'string' ] : nil,
    :gender, 'string',
    :staff, 'string',
    :birthdate, 'string',
    :passport_number, 'string',
    :passport_expiry, 'string',
    :passport_country, 'string',
    ].flatten.compact
    
    @participants = []
    
    loop_reports_viewers(@projects_ids, @include_pref1_applns, true) do |ac,a,v,p|
      
      ec_entry  = p.emerg if p
      birthdate = ec_entry ? ec_entry.emerg_birthdate : ' '
      passport_info = get_passport_info(ac, p, a, ec_entry)

      gender = if p then p.gender else '?' end
      title = if p then p.title else '' end
      
      if v && p
        last_name = p.person_lname.capitalize
	first_name = p.person_fname.capitalize
      elsif v && !p
        last_name = 'no person'
        first_name = "vid #{v.viewer_userID}"
      elsif !v && !p
        last_name = 'no viewer'
	first_name = ''
	first_name = ''
      end

      student = if v then (v.is_student?(@eg) ? '' : 'staff') else '?' end

      @participants << [ title, last_name, first_name,
        @include_pref1_applns ? (ac ? 'accepted' : a.status) : nil, 
        @many_projects ? (ac ? ac.project.title : a.preference1.title) : nil, 
        gender, student, birthdate, passport_info, 
        ].compact
    end
    
    @page_title = "#{@eg.title} #{@project_title} Travel List #{@include_pref1_applns ? ' plus pref1s' : ''}"
    render_report @participants
  end
  
  # returns a select list with viewers who are accepted to the projects given
  def viewers_with_profile_for_project
    acceptances = Acceptance.find_all_by_project_id @projects_ids, :include => { :viewer => :persons }
    @accepted_viewers = acceptances.collect &:viewer
    
    # TODO: do we need to worry about StaffProfiles ?
    #@viewer.is_project_director? || @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_project_administrator? || @viewer == v
    
    @accepted_viewers.sort!{ |a,b| a.name <=> b.name }
    @id = params[:dom_id]
    render :layout => !request.xml_http_request?
  end
  
  def cost_items
   @page_title = "People for " + if @cost_items.size == @eg.cost_items.size then
        "All Cost Items"
      elsif @cost_items.size == 1
        "Cost Item " + @cost_items[0].shortDesc
      else
        "Chosen Cost Items"
      end + " in " + if @projects.size == @eg.projects.size then
        "Any Project"
      elsif @projects.size == 1
        @projects[0].title
      else
        "Various Projects"
      end

    @columns = MyOrderedHash.new [
    :name, 'string',
    :gender, 'string',
    :staff, 'string',
    @many_projects ? [ :project, 'string' ] : nil,
    :received, 'currency',
    :claimed, 'currency',
    :target, 'currency',
    :outstanding, 'currency',
    ].flatten.compact

    @participants = []
    added_profile_id = [] 

    for ci in @cost_items
      for profile in (ci.optional? ? 
       ci.optins.collect{ |optin| optin.profile } : 
       Profile.find_all_by_project_id(ci.project.id))

        next if profile.nil? || !@projects.include?(profile.project)
        v = profile.viewer
        p = v.person
        next if v.nil? || p.nil? || added_profile_id[profile.id]
        added_profile_id[profile.id] = true

        @participants << funding_details_for_participant(profile, v, p)
      end
    end

    render_report @participants, :action => :funding_status
  end

  def cost_items_for_project
    @cost_items = []
    @projects.each do |p|
      @cost_items += p.all_cost_items(@eg)
    end
    @cost_items = @cost_items.uniq
    @id = params[:dom_id]
  end

  def prep_items_for_project
    @prep_items = []
    @projects.each do |p|
      @prep_items += p.prep_items
    end
    @prep_items += @eg.prep_items
    @prep_items = @prep_items.uniq
    @id = params[:dom_id]
  end
  
  def interns
    @columns = MyOrderedHash.new [
    :last_name, 'string', 
    :first_name, 'string',
    @many_projects ? [ :project, 'string' ] : nil,
    :gender, 'string',
    :email, 'string',
    ].flatten.compact
    
    @participants = []
    loop_reports_viewers(@projects_ids, @include_pref1_applns, false) do |ac,a,v,p|
      if ac && ac.as_intern?
        gender = p.gender
      
        @participants << [ p.person_lname.capitalize, p.person_fname.capitalize, 
          @many_projects ? (ac ? ac.project.title : a.preference1.title) : nil, 
          gender, p.person_email ].compact
      end
    end
    
    @page_title = "#{@eg.title} #{@project_title} Interns"
    render_report @participants
  end
  
  def travel_segment
    @travel_segments_hash = {}
    @travel_segments.each do |ts|
      @travel_segments_hash[ts] = []
      ts.profiles.each do |p|
        @travel_segments_hash[ts] << [ p.viewer.name, p.project, p ]
      end
    end
    
    if @travel_segments.size == TravelSegment.find(:all).length 
      tag = "all Travel Segments" 
    elsif @travel_segments.size == 1
      tag = "Travel Segment " + (@travel_segments[0].short_desc if !csv_requested).to_s
    else
      tag = "selected Travel Segments"
    end
    
    @page_title = "#{@eg.title} #{@project_title} Profiles with " + tag
     
    @include_profiles = [true.to_s, 1.to_s].include? params[:include_profiles].to_s
    
    # restrict profile columns
    @editors = 'restricted'
    
    render_report @profiles, :action => :grouped_itinerary
  end
  
  def custom_itinerary_report
    @travel_segments = if params[:include_old] != 'true' then
        TravelSegment.current
      else
        TravelSegment.find(:all)
      end

    @travel_segments.sort!
  end 
  
  def custom_itinerary
    travel_segment
  end
  
  def show_custom_itinerary_report
    puts params.inspect
  end
  
  def  filter_travel_segments
    custom_itinerary_report
  
    @travel_segments = TravelSegment.filter(@travel_segments, params)
    
    render  :partial  => 'ts_filter_list', 
            :locals   => { :sortable => true },
            :object   => @travel_segments
  end
  
  def manual_donations
    @columns = MyOrderedHash.new( [
      :last_name, 'string',
      :first_name, 'string',
      :project, 'string',
      :created_at, 'string',
      :type, 'string',
      :orig_amount, 'currency',
      :rate, 'string',
      :cad_amount, 'currency',
      :status, 'string'
    ] )

    projects = Project.find @projects_ids,
                 :include => :profiles,
                 :select => "#{Profile.table_name}.motivation_code"
    motivation_codes = projects.collect{ |p|
                      p.profiles.collect(&:motivation_code)
                    }.flatten.reject{ |mc| mc == '0' }

    conditions_str = ""; conditions_var = []
    if params[:type] && params[:type] != 'all'
      type = DonationType.find_by_description params[:type]
      if type
        conditions_str += "donation_type_id = ?" if params[:type]
        conditions_var << type.id
      end
    end
    if params[:status] && params[:status] != 'any' && type && type.description == 'USDMANUAL'
      conditions_str += " AND status = ?"
      conditions_var << params[:status]
    end

    donations = ManualDonation.find_all_by_motivation_code motivation_codes, 
                   :include => :donation_type_obj,
                   :conditions => [ conditions_str, *conditions_var ]

    @rows = []
    loop_reports_viewers(@projects_ids, @include_pref1_applns) do |ac,a,v,p|
      for d in donations.find_all{ |d| d.motivation_code == ac.motivation_code }
        @rows << [ p.last_name, p.first_name, ac.project.title,
                   d.created_at, d.donation_type, d.original_amount_display, 
                   d.conversion_rate_display, d.amount, d.status ]
      end
    end

    @page_title = "Manual Donations #{@projects.collect(&:title).join(',')}"

    render_report @rows
  end

  
  def prep_items
    # at this point we are guaranteed to have @projects and @prep_items set as
    # arrays of projects and prep_items, respectively
    @page_title = "Prep Items for " + if @projects.size == @eg.projects.size then
        "All Projects"
      elsif @projects.size == 1
        @projects[0].title
      else
        "Various Projects"
      end

    columns_arr = [
      :name, 'string',
      :project, 'string'
    ]

    i = 1
    for prep_item in @prep_items
     columns_arr += [ "#{prep_item.title}#{" (rec#{i})" if csv_requested}", 'string']
     columns_arr += [ "(sub#{i})", 'string' ] if csv_requested
     i += 1
    end

    #for i in 1 .. @prep_items.size
    #columns_arr += [
     # ("Form " + i.to_s).to_sym, 'string',
      #("s" + i.to_s).to_sym, 'boolean',
      #("r" + i.to_s).to_sym, 'boolean']
    #end
    
    @columns = MyOrderedHash.new columns_arr

    # ensure profile_prep_items is current
    @prep_items.each { |pi| pi.ensure_all_profile_prep_items_exist }
    @profiles = @prep_items.collect(&:profiles).flatten.uniq
    @profiles.delete_if{ |profile| !@projects.include?(profile.project) }
    @participants = []
    
    for profile in @profiles
      row = []
      row += [ profile.viewer.name, profile.project.name ]
      for prep_item in @prep_items
        profile_prep_item = profile.profile_prep_item prep_item

        if prep_item.applies_to_profile_check_optional(profile) && profile_prep_item

          if csv_requested
            check_r = if profile_prep_item.received then "Y" else "n" end
            check_s = if profile_prep_item.submitted then "Y" else "n" end
            aray += [ check_r, check_s ]
          else
            check_r = if profile_prep_item.received then "[&#x2713;]" else "[&nbsp;]" end
            check_s = if profile_prep_item.submitted then "[&#x2713;]" else "[&nbsp;]" end
            check_r_html = "<p class='prep_items_received_column'>#{check_r}</p>"
            check_s_html = "<p class='prep_items_submitted_column'>#{check_s}</p>"

            row += [ check_r_html, check_s_html ]
          end
        else
          row += [ csv_requested ? "" : "&nbsp" ] * 2
        end
      end

      @participants << row
    end

    render_report @participants
  end
  
  
  protected
  
  def csv_requested
    [ 'csv', 'excel (csv)' ].include? params[:format]
  end

  def try_to_delete_invalid_apps
    Appln.delete_those_with_invalid_viewers
  end

  def get_passport_info(ac, p, a, ec_entry)
    if ec_entry
        PassportInfo.new(ec_entry.emerg_passportNum,
          ec_entry.emerg_passportExpiry,
          ec_entry.emerg_passportOrigin)
    else
      PassportInfo.new('', '', '')
    end
  end

 # helper for all the reports, handles the rendering to csv or html
  def render_report(rows, params2 = {})
    params2[:action] ||= params[:action]
    @pdf = true if params[:format] == 'pdf'

    # this should use respond_to eventually, I can't get it to work right now though
    # so I'll do it the old-fashioned way    
    if csv_requested
      now = Time.now.strftime("%A %B %d %Y")
      filename = @page_title || params[:action]
      filename.gsub!('  ', ' ')
      
      headers['Content-Type'] = "text/csv"
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}.csv\""
      headers['Cache-Control'] = ''
      
      csv_title = "#{filename} generated #{now}"#.gsub(' ',',')
      @title = csv_title

      csv_template = "#{params2[:action]}_csv.rhtml"
      if FileTest.exists?("app/views/reports/#{csv_template}")
        render :action => csv_template, :layout => false
      else
        render :inline => to_csv(csv_title, @columns, rows)
      end
    else
      @sortable = params2[:sortable].nil? ? true : params2[:sortable] 
      
      render :action => params2[:action], :layout => @@reports_layout
    end
  end
  
  # grabs the columns specified from the values, in the order given in columns
  def get_rows(values, columns)
    columns = columns.collect { |c| c.class == Array ? c[0] : c }
    values.collect { |v|
      columns.collect { |c|
        v[c.to_s]
      }
    }
  end
  
  # Returns a columns ordered hash (which is then used in the javascript sorting)
  # by using the type info in the db already
  # 
  # Format for columns is array of either model_column_name which uses the same name in the report
  #   or [ model_column_name, report_column_name ]
  # 
  # Example: columns = [ 'donor_name', [ 'donation_type', 'type' ], 'amount' ]
  #       then the report will have donor_name, type, amount as its column names, with the 
  #       appropriate value
  #       
  # Filters by taking only the columns in columns
  def columns_from_model(model, columns)
    model_columns = columns.collect { |c| c.class == Array ? c.first : c }
    model_columns_to_report_columns = columns.collect { |c| c.class == Array ? c : [ c, c ] }
    report_columns = model_columns_to_report_columns.collect{ |c| c.second }
    
    MyOrderedHash.new( model.columns.collect { |c|
      if model_columns.include? c.name
        [ model_columns_to_report_columns.assoc(c.name.to_s)[1], c.type.to_s ]
      else nil
      end
    }.compact.sort { |a,b| # at this point each entry is an array [ name, type ]
      report_columns.index(a[0].to_s) <=> report_columns.index(b[0].to_s)
    }.flatten )
  end
  
  # refactored out so that cm2007 can use this registrants list and take only those applying to cm2007
  # 
  def registrants_only
    @columns = MyOrderedHash.new( [
      :last_name, 'string', 
      :first_name, 'string',
      :gender, 'string',
      @eg.has_your_campuses ? [ :campus, 'string' ] : nil,
      @eg.has_your_campuses ? [ :year, 'int' ] : nil,
      :status, 'string',
      :pref1, 'string',
      :pref2, 'string',
      :accepted, 'string',
      :phone, 'string',
      :email, 'string'
    ].flatten.compact )
    @rows = [ ]
    
    Viewer.find(:all, :include => :persons).each do |v|
      p = v.person
      if !v.is_student?(@eg) || p.nil?
        next
      end
      @as = v.applns.find(:all, :include => :form)
      @as.reject! { |a| a.form.event_group_id.nil? || a.form.event_group_id != @eg.id }

      next if @as.empty?
      @a = @as[0]
      
      p1 = (@a && @a.preference1) ? @a.preference1.title : ''
      p2 = (@a && @a.preference2) ? @a.preference2.title : ''
      
      accepts = @a.nil? ? nil : Acceptance.find_all_by_appln_id(@a.id)
      @acceptance_obj = accepts.nil? ? nil : accepts.find { |acc| acc.project.event_group_id == @eg.id }
      acceptance = @acceptance_obj ? @acceptance_obj.project.title : ''
      
      if !( (@a && @a.preference1_id && @projects_ids.include?(@a.preference1_id)) || 
       (@acceptance_obj && @projects_ids.include?(@acceptance_obj.project_id)))
        next
      end
      
      status = @a.nil? ? "has_account" : @a.status
      
      gender = p.gender
      
      registrant = Registrant.new(p.person_lname, p.person_fname, gender,
                                  (if !@eg.has_your_campuses then :skip elsif p.campuses[0] then p.campuses[0].campus_shortDesc else '' end), 
                                  (if !@eg.has_your_campuses then :skip elsif p.campuses[0] then p.person_year.year_in_school.year_desc else '' end),
      status, p1, p2, acceptance, p.person_local_phone, p.person_email)
      
      if block_given?
        yield v, @a, registrant
      end
      
      @rows << registrant
    end
  end
  
  def emergency_contact_columns(prefix)
    MyOrderedHash.new [
    :"#{prefix}name", 'string', 
    :"#{prefix}relation", 'string', 
    :"#{prefix}home_number", 'string', 
    :"#{prefix}work_number", 'string', 
    :"#{prefix}cell_number", 'string',
    :"#{prefix}email", 'string'
    ]
  end
  
  def emergency_contact(prefix, instance)
    prefix = prefix.to_s
    
    EmergencyContact.new(
                         extract_form_answer(:"emergency_contact_#{prefix}_name", instance),
    extract_form_answer(:"emergency_contact_#{prefix}_relationship", instance),
    extract_form_answer(:"emergency_contact_#{prefix}_home_phone", instance),
    extract_form_answer(:"emergency_contact_#{prefix}_work_phone", instance),
    extract_form_answer(:"emergency_contact_#{prefix}_cell_phone", instance),
    extract_form_answer(:"emergency_contact_#{prefix}_email", instance)
    )
  end
  
  def set_permissions_level
    @is_staff = !@viewer.is_student?(@eg)
    @is_eventgroup_coordinator = @viewer.is_eventgroup_coordinator?(@eg)
    true
  end
  
  def ensure_is_general_staff
    render(:inline => 'Must be staff') unless @is_staff
  end

  def ensure_is_eventgroup_coordinator
    render(:inline => 'Must be eventgroup coordinator') unless @is_eventgroup_coordinator
  end
  
  @@reports_layout = 'report'
  
 # @@year_eg_id = (EventGroup.find_by_title('2007') || EventGroup.find(:first)).id.to_i
 	
  @@form_elements = { 2 => {  # 2007 Campus Ministry Projects
      :title => 7,
      :first_name => 9,
      :middle_name => 10,
      :last_name => 11,
      :curr_province => 23,
      :perm_province => 35,
      :phone => 26,
      :cell => 27,
      :campus_year => 91, 
      :leadership_rating => 592, 
      :leadership_a => 593, 
      :leadership_b => 594, 
      :leadership_c => 595, 
      :training_rating => 596, 
      :training_a => 597,
      :training_b => 598,
      :training_c => 599,
      :birthdate => 12,
      :passport_number => 84,
      :passport_country_origin => 83,
      :passport_expiry => 85,
      :attending_cm => 101,
      :cm_travel_with_group => 102,
      :cm_plans => 103,
      :travel_request_notes => 119,
      :departure_city => 106,
      :departure_other => 117,
      :emergency_contact_1_name => 47,
      :emergency_contact_1_relationship => 48,
      :emergency_contact_1_home_phone => 49,
      :emergency_contact_1_work_phone => 50,
      :emergency_contact_1_cell_phone => 51,
      :emergency_contact_1_email => 52,
      :emergency_contact_2_name => 55,
      :emergency_contact_2_relationship => 56,
      :emergency_contact_2_home_phone => 57,
      :emergency_contact_2_work_phone => 58,
      :emergency_contact_2_cell_phone => 59,
      :emergency_contact_2_email_phone => 60,
      :emergency_conditions => 69,
      :emergency_conditions_description => 70,
      :emergency_medication_needed => 71,
      :emergency_medication_with => 72,
    }, 3 => {
      :campus_year => 727,
      :phone => 661,
      :cell => 662,
      :leadership_rating => 1234, 
      :leadership_a => 1235, 
      :leadership_b => 1236, 
      :leadership_c => 1237, 
      :training_rating => 1238, 
      :training_a => 1239,
      :training_b => 1240,
      :training_c => 1241,
      :training_d => 1242,
    }, 21 => {
      :phone => 6621,
      :cell => 6622,
    },
      6 => {
      :title => 1357,
      :first_name => 1359,
      :middle_name => 1360,
      :last_name => 1361,
      :curr_province => 1373,
      :perm_province => 1385,
      :phone => 1376,
      :cell => 1377,
      :campus_year => 91, 
      :leadership_rating => 1234, 
      :leadership_a => 1235, 
      :leadership_b => 1236, 
      :leadership_c => 1237, 
      :training_rating => 1238, 
      :training_a => 1239,
      :training_b => 1240,
      :training_c => 1241,
      :training_d => 1242,
      :birthdate => 1362,
      :passport_number => 1435,
      :passport_country_origin => 1434,
      :passport_expiry => 1436,
      :attending_cm => 101,
      :cm_travel_with_group => 102,
      :cm_plans => 103,
      :travel_request_notes => 119,
      :departure_city => 106,
      :departure_other => 117,
      :emergency_contact_1_name => 1398,
      :emergency_contact_1_relationship => 1399,
      :emergency_contact_1_home_phone => 1400,
      :emergency_contact_1_work_phone => 1401,
      :emergency_contact_1_cell_phone => 1402,
      :emergency_contact_1_email => 1403,
      :emergency_contact_2_name => 1406,
      :emergency_contact_2_relationship => 1407,
      :emergency_contact_2_home_phone => 1408,
      :emergency_contact_2_work_phone => 1409,
      :emergency_contact_2_cell_phone => 1410,
      :emergency_contact_2_email_phone => 1411,
      :emergency_conditions => 1420,
      :emergency_conditions_description => 1421,
      :emergency_medication_needed => 1422,
      :emergency_medication_with => 1423,
    } }
  
  # adds any nested elements from @@form_elements
  def ReportsController.include_nested_elements(elements, eg_id)
    elements.each do |e|
      @@form_elements[eg_id][e.id] = e.id
      
      # add any sub-elements
      if !e.elements.empty?
        include_nested_elements e.elements
      end
    end
  end
  begin
    # TODO: eventually we'll have to go over all event group ids..
    include_nested_elements(Element.find(@@form_elements[@@year_eg_id].values))
  rescue
  end
  
  def bool_to_yesno(v)
    v == '1' ? 'Yes' : 'No'
  end
  
  def element(form)
  end
  
  def extract_form_question_and_answer(element_symbol, instance)
    e = get_element @@form_elements[@eg.id][element_symbol]
    e.text + ": " + get_displayable_answer(e, instance)
  end
  
  def extract_form_answer(element_symbol, instance)
    e = get_element @@form_elements[@eg.id][element_symbol]
    get_displayable_answer e, instance
  end
  
  def get_displayable_answer(element, instance)
    params = if @answers_cache && !@answers_cache.empty?
      { :cache => @answers_cache, :use_cache_only => true }
    else {} end
    answer = element.get_answer(instance, params) || '' if element
    
    if element.class == YesNo
      answer = bool_to_yesno(answer)
    elsif element.class == Group
      element.elements.each do |e|
        answer += ' ' + get_displayable_answer(e, instance)
      end
    elsif element.class == Multicheckbox
      element.elements.each do |e|
        a = e.get_answer(instance, params)
        answer += e.text if a == "true" || a == "1"
      end
    end
    
    answer.to_s
  end
  
  def get_element(id)
    @element_cache ||= {}
    begin
      @element_cache[id] || @element_cache[id] = Element.find(id)
    rescue
      nil
    end
  end
  
  def set_title
    @page_title = "Reports"
    @submenu_title = "Standard Reports"
  end
  
  def set_projects
    requested_projects = (params[:project_id] == 'all' || !params[:project_id]) ? 
        @eg.projects : @eg.projects.find(params[:project_id].split(','))
    
    @include_pref1_applns = params[:include_pref1s]
    
    @projects = []
    requested_projects.each do |project|
      # ensure the user has permission to access this project
      @viewer.set_project project
      if @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_project_director? || 
        @viewer.is_project_administrator? || @viewer.is_project_staff?
        @projects << project
      end
    end
    
    if @projects.size == 1
      @project_title = @projects[0].title
    else
      @project_title = ''
    end
    @projects_ids = @projects.collect{ |p| p.id }
    @many_projects = @projects_ids.size > 1
    true
  end
  
  def set_travel_segment
    if params[:ts]
      @travel_segments = TravelSegment.find params[:ts].keys
    elsif params[:travel_segment_id] == 'all'
      @travel_segments = TravelSegment.find_all_by_event_group_id @eg.id
    else
      @travel_segments = [ TravelSegment.find(params[:travel_segment_id]) ]
    end
  end
  
  def set_cost_items
    @cost_items = if params[:cost_item_id] == 'all' then
      CostItem.find :all
    else
      CostItem.find params[:cost_item_id].split(',')
    end
  end

  def set_prep_items
    includes = [ :projects, :event_group ]

    @prep_items = if params[:prep_item_id].nil? || params[:prep_item_id] == 'all' then
      PrepItem.find :all, :include => includes
    else
      PrepItem.find params[:prep_item_id].split(','), :include => includes
    end
    
    # ensure @prep_items apply to some project
    @prep_items.delete_if { |pi|
       if pi.applies_to == :projects
         (@projects & pi.projects).empty?
       elsif pi.applies_to == :event_group
         pi.event_group != @eg
       end
    }
  end

  def set_viewer
    @report_viewer ||= Viewer.find params[:viewer_id]
  end

  def to_csv(report_info, headers, rows)
    # add the report info
    csv = report_info + "\r\n\r\n"
    
    # table headers
    csv += headers.keys.collect { |k| k.to_s }.join ','
    csv += "\r\n"
    
    # values
    csv += rows.inject('') do |csv, row|
      
      formatted_vals = []
      row.to_a.each_with_index do |v,i|
        formatted_vals << values(v, headers[i])
      end
      formatted_vals.flatten!
      formatted_vals = formatted_vals.collect { |fv| '"' + fv.to_s.gsub('"', '""') + '"' }
      csv + formatted_vals.join(',') + "\r\n"
    end
    
    csv
  end
  
  def values(o, header)
    if header == 'currency'
      "%0.2f" % v.to_f
    elsif o.respond_to?('values')
      o.values
    else
      o
    end
  end
  
  def set_skip_title
    @skip_title = request.xml_http_request?
    true
  end
  
end

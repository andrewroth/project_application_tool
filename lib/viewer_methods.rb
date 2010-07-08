module ViewerMethods
  
  def self.included(base)
    base.class_eval do
      has_one :preferences
      has_many :profiles

      has_many :applns
      #has_many :tickets # this not used?

      #has_many :persons, :through => :access

      has_many :notification_acknowledgments
      has_one :projects_coordinator, :conditions => { :end_date => nil }
      has_one :all_projects_coordinator, :class_name => "ProjectsCoordinator"

      has_many :eventgroup_coordinators, :conditions => { :end_date => nil }
      has_many :all_eventgroup_coordinators, :class_name => "EventgroupCoordinator"
      has_many :eventgroups_coordinating, :class_name => "EventGroup", :through => :eventgroup_coordinators, :source => :event_group

      # ------ roles
      def base.roles() [ :project_staff, :project_director, :project_administrator, :support_coach, :processor ] end
      def base.roles_pair() roles.collect { |r| [ r, r.to_s.pluralize.to_sym ] } end
      def base.roles_plural() roles_pair.collect{ |pair| pair[1] } end
      def base.project_role_syms() Viewer.roles.collect{ |r| :"#{r}_projects" } end

      for role_s, role_p in Viewer.roles_pair
        has_many :"#{role_p}", :conditions => { :end_date => nil }
        has_many :"all_#{role_p}", :class_name => role_s.to_s.camelize
      end

      for role_s, role_p in Viewer.roles_pair
        has_many :"#{role_s}_projects", :through => :"#{role_p}", :source => "project"
      end

      # returns an array with all projects where this user is one of the
      # project roles
      def projects_with_any_role
        (Viewer.roles.inject([]) { |projects, role| projects + self.send(:"#{role}_projects") }).uniq
      end
      def current_projects_with_any_role(eg)
        return [] if eg.nil?
        projects_with_any_role.reject { |p| p.event_group_id != eg.id }
      end
      # ------ end roles

      def timezone_name
        if preferences.nil?
      ''
        else
          preferences.time_zone
        end
      end

      # shortcut
      def name
        (person.nil?) ? username : person.full_name
      end

      def email
        (person == nil) ? "no_email_for_student@campusforchrist.org" : person.email
      end

      def phone
        person.try(:current_address).try(:phone)
      end

      # helper methods for access groups
      def is_student?(eg)
        @is_student.nil? ?
          @is_student = !is_staff?(eg) : @is_student
      end

      def is_staff?(eg)
        person.is_staff_somewhere? || is_eventgroup_coordinator?(eg) || !projects_with_any_role.empty?
      end

      def is_current_staff?(eg)
        person.is_hrdb_staff? || is_eventgroup_coordinator?(eg) || !current_projects_with_any_role(eg).empty?
      end

      def is_eventgroup_coordinator?(eg)
        return true if is_projects_coordinator?
        return false unless eg

        @is_eventgroup_coordinator ||= {}
        return @is_eventgroup_coordinator[eg.id] unless @is_eventgroup_coordinator[eg.id].nil?
        @is_eventgroup_coordinator[eg.id] = is_eventgroup_coordinator_without_cache?(eg)
      end

      def is_eventgroup_coordinator_without_cache?(eg)
        return true if is_projects_coordinator?

        c_eg = eg
        while (c_eg != nil)
          return true if c_eg.eventgroup_coordinators.find_by_viewer_id id

          c_eg = c_eg.parent
        end

        false
      end

      def is_projects_coordinator?
        if @is_projects_coordinator.nil?
          @is_projects_coordinator = !projects_coordinator.nil?
        else
          @is_projects_coordinator
        end
      end

      def in_access_group?(key)
        !accessgroups.find_all{ |ag| ag.accessgroup_key == key }.empty?
      end

      def in_access_group_by_id?(id)
        !accessgroups.find_all{ |ag| ag.accessgroup_id == id }.empty?
      end

=begin
There's a bunch of logic for creating users in cim_hrdb.

// 1. create new viewer

    * language_id=1
    * isActive=true
    * accountGroupID=15; // the 'unknown' group

// 2. access groups

    * ALL_ACCESS_GROUP ; // add to the 'all' access group

// 3. create new person

// 4. create an access table entry for this (viewer,person) combo
=end
=begin
      def self.create_new_cim_hrdb_account(guid, fn, ln, uid)
        # first and last names can't be nil
        fn ||= ''
        ln ||= ''

        v = Viewer.create! :guid => guid, :viewer_lastLogin => 0, :accountgroup_id => 15, :viewer_userID => uid, :language_id => 1, :viewer_isActive => true, :accountgroup_id => 15 
        p = Person.create! :person_fname => fn, :person_lname => ln, :person_legal_fname => '', :person_legal_lname => ''
        ag_all = Accessgroup.find_by_accessgroup_key '[accessgroup_key1]'
        Vieweraccessgroup.create! :viewer_id => v.id, :accessgroup_id => ag_all.id
        Access.create :viewer_id => v.id, :person_id => p.id

        v
      end
=end

=begin
      def create_person
        raise "person already created" if person

        p = Person.create! :person_fname => '', :person_lname => '', :person_legal_fname => '', :person_legal_lname => ''
        ag_all = Accessgroup.find_by_accessgroup_key '[accessgroup_key1]'
        Vieweraccessgroup.create! :viewer_id => self.id, :accessgroup_id => ag_all.id
        Access.create :viewer_id => self.id, :person_id => p.id

        @person = p
      end
=end

      #====== from user.rb

      def fullview?
        return is_projects_coordinator? unless @project
        set_project @project
        eg = @project.event_group

        is_eventgroup_coordinator?(eg) || 
          is_project_administrator? || 
          is_project_director? || 
          is_processor?
      end

      def is_assigned_regional_or_national?() 
        return false if person.nil?
        !person.assignments.find_all_by_campus_id(Campus.regional_national_id).empty?
      end

      def assert_project_set 
        if (@project.nil?)
          throw "Sorry, can't determine project-specific roles until you call set_project!"
        end
      end

      def is_project_director?() assert_project_set; @is_project_director end
      def is_project_administrator?() assert_project_set; @is_project_administrator end
      def is_support_coach?() assert_project_set; @is_support_coach end
      def is_project_staff?() assert_project_set; @is_project_staff end
      def is_processor?() assert_project_set; @is_processor end

      # returns true iff user can modify the given profile
      def can_modify_profile_in_project(p)
        set_project(p)
        (is_eventgroup_coordinator?(p.event_group) || is_processor? || 
         is_project_director? || is_project_administrator?)
      end

      def set_project(project)
        if (@project == project || project.nil?)  
          return true
        end
        @project = project
        @is_project_director = !project_director_projects.find_all{ |p| p.id == project.id }.empty?
        @is_project_administrator = !project_administrator_projects.find_all{ |p| p.id == project.id }.empty?
        @is_support_coach = !support_coach_projects.find_all{ |p| p.id == project.id }.empty?
        @is_project_staff = !project_staff_projects.find_all{ |p| p.id == project.id }.empty?
        @is_processor = !processor_projects.find_all{ |p| p.id == project.id }.empty?
        true
      end

      # returns a string status of the user's role related to project, useful for cache naming
      def roles_wrt_project(project)
        return 'projects_coordinator' if is_projects_coordinator?

        set_project(project)

        roles = []
        for role in [ 'project_director', 'project_administrator', 'support_coach', 'project_staff', 'processor' ]
          if eval("@is_#{role}")
            roles << role
          end
        end
        roles << 'unknown' if roles.empty?
        roles.join(',')
      end

      def is_atleast_project_staff(project)
        !current_projects_with_any_role(project.event_group).find { 
          |project_user_is_staff_on| project_user_is_staff_on == project 
        }.nil?
      end

      def is_any_project_staff(eg)
        !current_projects_with_any_role(eg).empty?
      end

      def can_evaluate?
        is_projects_coordinator? || is_processor?   
      end

      def viewer_userID
        self.username
      end

      def viewer_lastLogin
        self.last_login
      end

      def viewer_id
        self.id
      end
    end
  end
end

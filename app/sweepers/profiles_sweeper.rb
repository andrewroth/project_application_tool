class ProfilesSweeper < ActionController::Caching::Sweeper
  observe Profile

  PROFILE_ATTS_USED_BY_SECTIONS = {
    'Acceptance' => [ :accepted_at, :support_claimed, :support_coach_id, :as_intern ],
    'Applying' => [ :accepted_at, :support_claimed, :support_coach_id, :as_intern, :locked_by ],
    'StaffProfile' => [ :motivation_code ],
    'Withdrawn' => [ :status, :class_when_withdrawn, :status_when_withdrawn, :withdrawn_by, :withdrawn_at, :reason, :notes ]
  }

  def after(controller)
    return if self.controller.nil?
    super
  end

  def profile_changed_wrt_section(profile, section)
    # check for moving from one section to another (both orig & new sections change)
    logger.info "sweeper checking section #{section} (profile's class #{profile.class.name}, type #{profile[:type]}, orig type #{profile.orig_atts['type']})" if logger
    return true if profile.att_changed(:type) && 
               ( [ profile[:type], profile.class.name, profile.orig_atts['type'] ].include?(section) )
    # check for moving project, if so then only the current section should be updated
    #   (though see special case which will clear out the original section
    #     for the original project)
    return true if profile.att_changed(:project_id) && profile.class.name == section
    # and new records cause an update as well
    return true if profile.new_record?

    # since it hasn't changed sections (which is the first check done in this method)
    #   then we know that the cache does not need to be cleared if the section
    #   being considered right now is different than the section the profile is
    #   in
    return false if profile.class.name != section
    logger.info "  checking atts #{PROFILE_ATTS_USED_BY_SECTIONS[section].inspect}" if logger

    # no obvious cases above triggered then go through each attribute
    for att in PROFILE_ATTS_USED_BY_SECTIONS[section]
      return true if profile.att_changed(att)
    end
    
    return false
  end

  def before_save(profile)
    for section in [ 'Acceptance', 'Applying', 'StaffProfile', 'Withdrawn' ]
      if profile_changed_wrt_section(profile, section)
        logger.info "sweeper got that section #{section} changed" if logger
        #logger.info "sweeper orig_atts: #{profile.orig_atts.inspect}" if logger

        # clear old section cache if project changed (special case)
        if profile.att_changed(:project_id)
          #expire_fragment(:controller => 'main', :action => 'your_projects', 
          #            :section => profile.orig_atts['type'], 
          #            :project_id => profile.orig_atts['project_id'])
          logger.info "fragment: special case hit (project_id changed)" if logger
          expire_fragment(%r{your_projects.project_id=#{profile.orig_atts['project_id']}&role=.*&section=#{profile.orig_atts['type']}})
        end

        # update this section
        #expire_fragment(:controller => 'main', :action => 'your_projects', 
        #              :section => profile[:type], :project_id => profile[:project_id])
        expire_fragment(%r{your_projects.project_id=#{profile[:project_id]}&role=.*&section=#{section}})
      end
    end
  end
end

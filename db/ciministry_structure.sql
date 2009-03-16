CREATE TABLE `accountadmin_accesscategory` (
  `accesscategory_id` int(11) NOT NULL auto_increment,
  `accesscategory_key` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`accesscategory_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_accessgroup` (
  `accessgroup_id` int(11) NOT NULL auto_increment,
  `accesscategory_id` int(11) NOT NULL default '0',
  `accessgroup_key` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`accessgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_accountadminaccess` (
  `accountadminaccess_id` int(11) NOT NULL auto_increment,
  `viewer_id` int(11) NOT NULL default '0',
  `accountadminaccess_privilege` int(1) NOT NULL default '0',
  PRIMARY KEY  (`accountadminaccess_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_accountgroup` (
  `accountgroup_id` int(11) NOT NULL auto_increment,
  `accountgroup_key` varchar(50) NOT NULL default '',
  `accountgroup_label_long` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`accountgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_language` (
  `language_id` int(11) NOT NULL auto_increment,
  `language_key` varchar(25) NOT NULL default '',
  `language_code` char(2) NOT NULL default '',
  PRIMARY KEY  (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_viewer` (
  `viewer_id` int(11) NOT NULL auto_increment,
  `accountgroup_id` int(11) NOT NULL default '0',
  `viewer_userID` varchar(50) NOT NULL default '',
  `viewer_passWord` varchar(50) NOT NULL default '',
  `language_id` int(11) NOT NULL default '0',
  `viewer_isActive` int(1) NOT NULL default '0',
  `viewer_lastLogin` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`viewer_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2988 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_vieweraccessgroup` (
  `vieweraccessgroup_id` int(11) NOT NULL auto_increment,
  `viewer_id` int(11) NOT NULL default '0',
  `accessgroup_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`vieweraccessgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11038 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_access` (
  `access_id` int(50) NOT NULL auto_increment,
  `viewer_id` int(50) NOT NULL default '0',
  `person_id` int(50) NOT NULL default '0',
  PRIMARY KEY  (`access_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2753 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_admin` (
  `admin_id` int(1) NOT NULL auto_increment,
  `person_id` int(50) NOT NULL default '0',
  `priv_id` int(20) NOT NULL default '0',
  PRIMARY KEY  (`admin_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_assignment` (
  `assignment_id` int(50) NOT NULL auto_increment,
  `person_id` int(50) NOT NULL default '0',
  `campus_id` int(50) NOT NULL default '0',
  PRIMARY KEY  (`assignment_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1757 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_campus` (
  `campus_id` int(50) NOT NULL auto_increment,
  `campus_desc` varchar(128) NOT NULL default '',
  `campus_shortDesc` varchar(50) NOT NULL default '',
  `accountgroup_id` int(16) NOT NULL default '0',
  `region_id` int(8) NOT NULL default '0',
  PRIMARY KEY  (`campus_id`)
) ENGINE=MyISAM AUTO_INCREMENT=75 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_campusadmin` (
  `campusadmin_id` int(20) NOT NULL auto_increment,
  `admin_id` int(20) NOT NULL default '0',
  `campus_id` int(20) NOT NULL default '0',
  PRIMARY KEY  (`campusadmin_id`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_gender` (
  `gender_id` int(50) NOT NULL auto_increment,
  `gender_desc` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`gender_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_person` (
  `person_id` int(50) NOT NULL auto_increment,
  `person_fname` varchar(50) NOT NULL default '',
  `person_lname` varchar(50) NOT NULL default '',
  `person_phone` varchar(50) NOT NULL default '',
  `person_email` varchar(128) NOT NULL default '',
  `person_addr` varchar(128) NOT NULL default '',
  `person_city` varchar(50) NOT NULL default '',
  `province_id` int(50) NOT NULL default '0',
  `person_pc` varchar(50) NOT NULL default '',
  `gender_id` int(50) NOT NULL default '0',
  `assignment_id` int(50) NOT NULL default '0',
  `person_local_phone` varchar(50) NOT NULL default '',
  `person_local_addr` varchar(128) NOT NULL default '',
  `person_local_city` varchar(50) NOT NULL default '',
  `person_local_pc` varchar(50) NOT NULL default '',
  `person_local_province_id` int(50) NOT NULL default '0',
  PRIMARY KEY  (`person_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1795 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_priv` (
  `priv_id` int(20) NOT NULL auto_increment,
  `priv_accesslevel` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`priv_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_province` (
  `province_id` int(50) NOT NULL auto_increment,
  `province_desc` varchar(50) NOT NULL default '',
  `province_shortDesc` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`province_id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_region` (
  `region_id` int(50) NOT NULL auto_increment,
  `reg_desc` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`region_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_staff` (
  `staff_id` int(50) NOT NULL auto_increment,
  `person_id` int(50) NOT NULL default '0',
  PRIMARY KEY  (`staff_id`)
) ENGINE=MyISAM AUTO_INCREMENT=165 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_access` (
  `access_id` int(16) NOT NULL auto_increment,
  `staff_id` int(16) NOT NULL default '0',
  `priv_id` int(16) NOT NULL default '0',
  PRIMARY KEY  (`access_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_coordinator` (
  `coordinator_id` int(16) NOT NULL auto_increment,
  `access_id` int(16) NOT NULL default '0',
  `campus_id` int(16) NOT NULL default '0',
  PRIMARY KEY  (`coordinator_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_exposuretype` (
  `exposuretype_id` int(10) NOT NULL auto_increment,
  `exposuretype_desc` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`exposuretype_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_morestats` (
  `morestats_id` int(10) NOT NULL auto_increment,
  `morestats_exp` int(10) NOT NULL default '0',
  `morestats_notes` text NOT NULL,
  `week_id` int(10) NOT NULL default '0',
  `campus_id` int(10) NOT NULL default '0',
  `exposuretype_id` int(10) NOT NULL default '0',
  PRIMARY KEY  (`morestats_id`)
) ENGINE=MyISAM AUTO_INCREMENT=60 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_prc` (
  `prc_id` int(10) NOT NULL auto_increment,
  `prc_firstName` varchar(128) NOT NULL default '',
  `prcMethod_id` int(10) NOT NULL default '0',
  `prc_witnessName` varchar(128) NOT NULL default '',
  `semester_id` int(10) NOT NULL default '0',
  `campus_id` int(10) NOT NULL default '0',
  `prc_notes` text NOT NULL,
  `prc_7upCompleted` int(10) NOT NULL default '0',
  `prc_7upStarted` int(10) NOT NULL default '0',
  `prc_date` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`prc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=110 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_prcmethod` (
  `prcMethod_id` int(10) NOT NULL auto_increment,
  `prcMethod_desc` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`prcMethod_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_priv` (
  `priv_id` int(16) NOT NULL auto_increment,
  `priv_desc` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`priv_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_semester` (
  `semester_id` int(10) NOT NULL auto_increment,
  `semester_desc` varchar(64) NOT NULL default '',
  `semester_startDate` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`semester_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_semesterreport` (
  `semesterreport_id` int(10) NOT NULL auto_increment,
  `semesterreport_avgPrayer` int(10) NOT NULL default '0',
  `semesterreport_avgWklyMtg` int(10) NOT NULL default '0',
  `semesterreport_numStaffChall` int(10) NOT NULL default '0',
  `semesterreport_numInternChall` int(10) NOT NULL default '0',
  `semesterreport_numFrosh` int(10) NOT NULL default '0',
  `semesterreport_numStaffDG` int(10) NOT NULL default '0',
  `semesterreport_numInStaffDG` int(10) NOT NULL default '0',
  `semesterreport_numStudentDG` int(10) NOT NULL default '0',
  `semesterreport_numInStudentDG` int(10) NOT NULL default '0',
  `semesterreport_numSpMultStaffDG` int(10) NOT NULL default '0',
  `semesterreport_numSpMultStdDG` int(10) NOT NULL default '0',
  `semester_id` int(10) NOT NULL default '0',
  `campus_id` int(10) NOT NULL default '0',
  PRIMARY KEY  (`semesterreport_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_week` (
  `week_id` int(50) NOT NULL auto_increment,
  `week_endDate` date NOT NULL default '0000-00-00',
  `semester_id` int(16) NOT NULL default '0',
  PRIMARY KEY  (`week_id`)
) ENGINE=MyISAM AUTO_INCREMENT=204 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_weeklyreport` (
  `weeklyReport_id` int(10) NOT NULL auto_increment,
  `weeklyReport_1on1SpConv` int(10) NOT NULL default '0',
  `weeklyReport_1on1GosPres` int(10) NOT NULL default '0',
  `weeklyReport_1on1HsPres` int(10) NOT NULL default '0',
  `staff_id` int(10) NOT NULL default '0',
  `week_id` int(10) NOT NULL default '0',
  `campus_id` int(10) NOT NULL default '0',
  `weeklyReport_7upCompleted` int(10) NOT NULL default '0',
  `weeklyReport_1on1SpConvStd` int(10) NOT NULL default '0',
  `weeklyReport_1on1GosPresStd` int(10) NOT NULL default '0',
  `weeklyReport_1on1HsPresStd` int(10) NOT NULL default '0',
  `weeklyReport_7upCompletedStd` int(10) NOT NULL default '0',
  `weeklyReport_cjVideo` int(10) NOT NULL default '0',
  `weeklyReport_mda` int(10) NOT NULL default '0',
  `weeklyReport_otherEVMats` int(10) NOT NULL default '0',
  `weeklyReport_rlk` int(10) NOT NULL default '0',
  `weeklyReport_siq` int(10) NOT NULL default '0',
  `weeklyReport_notes` text NOT NULL,
  PRIMARY KEY  (`weeklyReport_id`)
) ENGINE=MyISAM AUTO_INCREMENT=494 DEFAULT CHARSET=latin1;

CREATE TABLE `gtw_projects` (
  `projects_id` int(10) NOT NULL auto_increment,
  `projects_desc` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`projects_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE `gtw_role` (
  `role_id` int(10) NOT NULL auto_increment,
  `role_desc` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`role_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `gtw_story` (
  `story_id` int(10) NOT NULL auto_increment,
  `story_email` varchar(128) NOT NULL default '',
  `story_name` varchar(128) NOT NULL default '',
  `campus_id` int(10) NOT NULL default '0',
  `projects_id` int(10) NOT NULL default '0',
  `story_story` text NOT NULL,
  `role_id` int(10) NOT NULL default '0',
  PRIMARY KEY  (`story_id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

CREATE TABLE `national_campus` (
  `campus_id` int(50) NOT NULL auto_increment,
  `campus_name` varchar(128) NOT NULL default '',
  `campus_shortName` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`campus_id`)
) ENGINE=MyISAM AUTO_INCREMENT=74 DEFAULT CHARSET=latin1;

CREATE TABLE `national_day` (
  `day_id` int(11) NOT NULL auto_increment,
  `day_date` date NOT NULL default '0000-00-00',
  PRIMARY KEY  (`day_id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

CREATE TABLE `national_signup` (
  `signup_id` int(11) NOT NULL auto_increment,
  `day_id` int(11) NOT NULL default '0',
  `time_id` int(11) NOT NULL default '0',
  `signup_name` varchar(128) NOT NULL default '',
  `campus_id` int(11) NOT NULL default '0',
  `signup_email` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`signup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1342 DEFAULT CHARSET=latin1;

CREATE TABLE `national_time` (
  `time_id` int(11) NOT NULL auto_increment,
  `time_time` time NOT NULL default '00:00:00',
  PRIMARY KEY  (`time_id`)
) ENGINE=MyISAM AUTO_INCREMENT=224 DEFAULT CHARSET=latin1;

CREATE TABLE `national_timezones` (
  `timezones_id` int(11) NOT NULL auto_increment,
  `timezones_desc` varchar(32) NOT NULL default '',
  `timezones_offset` int(11) NOT NULL default '0',
  PRIMARY KEY  (`timezones_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navbarcache` (
  `navbarcache_id` int(11) NOT NULL auto_increment,
  `viewer_id` int(11) NOT NULL default '0',
  `language_id` int(11) NOT NULL default '0',
  `navbarcache_cache` text NOT NULL,
  `navbarcache_isValid` int(1) NOT NULL default '0',
  PRIMARY KEY  (`navbarcache_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3734 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navbargroup` (
  `navbargroup_id` int(11) NOT NULL auto_increment,
  `navbargroup_nameKey` varchar(50) NOT NULL default '',
  `navbargroup_order` int(11) NOT NULL default '0',
  PRIMARY KEY  (`navbargroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navbarlinks` (
  `navbarlink_id` int(11) NOT NULL auto_increment,
  `navbargroup_id` int(11) NOT NULL default '0',
  `navbarlink_textKey` varchar(50) NOT NULL default '',
  `navbarlink_url` text NOT NULL,
  `module_id` int(11) NOT NULL default '0',
  `navbarlink_isActive` int(1) NOT NULL default '0',
  `navbarlink_isModule` int(1) NOT NULL default '0',
  `navbarlink_order` int(11) NOT NULL default '0',
  `navbarlink_startDateTime` datetime NOT NULL default '0000-00-00 00:00:00',
  `navbarlink_endDateTime` datetime NOT NULL default '9999-12-29 23:59:00',
  PRIMARY KEY  (`navbarlink_id`)
) ENGINE=MyISAM AUTO_INCREMENT=64 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navlinkaccessgroup` (
  `navlinkaccessgroup_id` int(11) NOT NULL auto_increment,
  `navbarlink_id` int(11) NOT NULL default '0',
  `accessgroup_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`navlinkaccessgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=95 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navlinkviewer` (
  `navlinkviewer_id` int(11) NOT NULL auto_increment,
  `navbarlink_id` int(11) NOT NULL default '0',
  `viewer_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`navlinkviewer_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `site_logmanager` (
  `log_id` int(11) NOT NULL auto_increment,
  `log_userID` varchar(50) NOT NULL default '',
  `log_dateTime` datetime NOT NULL default '0000-00-00 00:00:00',
  `log_recipientID` varchar(50) NOT NULL default '',
  `log_description` text NOT NULL,
  `log_data` text NOT NULL,
  `log_viewerIP` varchar(15) NOT NULL default '',
  `log_applicationKey` varchar(4) NOT NULL default '',
  PRIMARY KEY  (`log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

CREATE TABLE `site_multilingual_label` (
  `label_id` int(11) NOT NULL auto_increment,
  `page_id` int(11) NOT NULL default '0',
  `label_key` varchar(50) NOT NULL default '',
  `label_label` text NOT NULL,
  `label_moddate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `language_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`label_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3528 DEFAULT CHARSET=latin1;

CREATE TABLE `site_multilingual_page` (
  `page_id` int(11) NOT NULL auto_increment,
  `series_id` int(11) NOT NULL default '0',
  `page_key` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=207 DEFAULT CHARSET=latin1;

CREATE TABLE `site_multilingual_series` (
  `series_id` int(11) NOT NULL auto_increment,
  `series_key` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`series_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

CREATE TABLE `site_multilingual_xlation` (
  `xlation_id` int(11) NOT NULL auto_increment,
  `label_id` int(11) NOT NULL default '0',
  `language_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`xlation_id`),
  KEY `language_id` (`language_id`),
  KEY `label_id` (`label_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2515 DEFAULT CHARSET=latin1;

CREATE TABLE `site_page_modules` (
  `module_id` int(11) NOT NULL auto_increment,
  `module_key` varchar(50) NOT NULL default '',
  `module_path` text NOT NULL,
  `module_app` varchar(50) NOT NULL default '',
  `module_include` varchar(50) NOT NULL default '',
  `module_name` varchar(50) NOT NULL default '',
  `module_parameters` text NOT NULL,
  `module_systemAccessFile` varchar(50) NOT NULL default '',
  `module_systemAccessObj` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

CREATE TABLE `site_session` (
  `session_id` varchar(32) NOT NULL default '',
  `session_data` text NOT NULL,
  `session_expiration` int(11) NOT NULL default '0',
  PRIMARY KEY  (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `spt_ticket` (
  `ticket_id` int(8) NOT NULL auto_increment,
  `viewer_id` int(8) NOT NULL default '0',
  `ticket_ticket` varchar(64) NOT NULL default '',
  `ticket_expiry` int(16) NOT NULL default '0',
  PRIMARY KEY  (`ticket_id`)
) ENGINE=MyISAM AUTO_INCREMENT=97 DEFAULT CHARSET=latin1;


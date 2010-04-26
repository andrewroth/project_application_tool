-- MySQL dump 10.13  Distrib 5.1.32, for apple-darwin9.5.0 (i386)
--
-- Host: localhost    Database: c4c_intranet_prod
-- ------------------------------------------------------
-- Server version	5.1.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accountadmin_accesscategory`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accountadmin_accesscategory` (
  `accesscategory_id` int(11) NOT NULL AUTO_INCREMENT,
  `accesscategory_key` varchar(50) NOT NULL DEFAULT '',
  `english_value` text,
  PRIMARY KEY (`accesscategory_id`),
  KEY `ciministry.accountadmin_accesscategory_accesscateg` (`accesscategory_key`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `accountadmin_accessgroup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accountadmin_accessgroup` (
  `accessgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `accesscategory_id` int(11) NOT NULL DEFAULT '0',
  `accessgroup_key` varchar(50) NOT NULL DEFAULT '',
  `english_value` text,
  PRIMARY KEY (`accessgroup_id`),
  KEY `ciministry.accountadmin_accessgroup_accessgroup_ke` (`accessgroup_key`)
) ENGINE=MyISAM AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `accountadmin_accountadminaccess`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accountadmin_accountadminaccess` (
  `accountadminaccess_id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) NOT NULL DEFAULT '0',
  `accountadminaccess_privilege` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountadminaccess_id`),
  KEY `ciministry.accountadmin_accountadminaccess_viewer_` (`viewer_id`),
  KEY `ciministry.accountadmin_accountadminaccess_account` (`accountadminaccess_privilege`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `accountadmin_accountgroup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accountadmin_accountgroup` (
  `accountgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `accountgroup_key` varchar(50) NOT NULL DEFAULT '',
  `accountgroup_label_long` varchar(50) NOT NULL DEFAULT '',
  `english_value` text,
  PRIMARY KEY (`accountgroup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `accountadmin_language`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accountadmin_language` (
  `language_id` int(11) NOT NULL AUTO_INCREMENT,
  `language_key` varchar(25) NOT NULL DEFAULT '',
  `language_code` char(2) NOT NULL DEFAULT '',
  `english_value` text,
  PRIMARY KEY (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `accountadmin_viewer`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accountadmin_viewer` (
  `viewer_id` int(11) NOT NULL AUTO_INCREMENT,
  `guid` varchar(64) NOT NULL,
  `accountgroup_id` int(11) NOT NULL DEFAULT '0',
  `viewer_userID` varchar(50) NOT NULL DEFAULT '',
  `viewer_passWord` varchar(50) NOT NULL DEFAULT '',
  `language_id` int(11) NOT NULL DEFAULT '0',
  `viewer_isActive` int(1) NOT NULL DEFAULT '0',
  `viewer_lastLogin` date NOT NULL DEFAULT '0000-00-00',
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `email_validated` tinyint(1) DEFAULT NULL,
  `developer` tinyint(1) DEFAULT NULL,
  `facebook_hash` varchar(255) DEFAULT NULL,
  `facebook_username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`viewer_id`),
  KEY `ciministry.accountadmin_viewer_accountgroup_id_index` (`accountgroup_id`),
  KEY `ciministry.accountadmin_viewer_viewer_userID_index` (`viewer_userID`),
  CONSTRAINT `FK_viewer_grp` FOREIGN KEY (`accountgroup_id`) REFERENCES `accountadmin_accountgroup` (`accountgroup_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10639 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `accountadmin_vieweraccessgroup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accountadmin_vieweraccessgroup` (
  `vieweraccessgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) NOT NULL DEFAULT '0',
  `accessgroup_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`vieweraccessgroup_id`),
  KEY `ciministry.accountadmin_vieweraccessgroup_viewer_i` (`viewer_id`),
  KEY `ciministry.accountadmin_vieweraccessgroup_accessgr` (`accessgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=24676 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_c4cwebsite_projects`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_c4cwebsite_projects` (
  `projects_id` int(10) NOT NULL AUTO_INCREMENT,
  `projects_desc` varchar(50) NOT NULL DEFAULT '',
  `project_website` varchar(200) DEFAULT NULL,
  `project_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`projects_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_access`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_access` (
  `access_id` int(50) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(50) NOT NULL DEFAULT '0',
  `person_id` int(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`access_id`),
  KEY `ciministry.cim_hrdb_access_viewer_id_index` (`viewer_id`),
  KEY `ciministry.cim_hrdb_access_person_id_index` (`person_id`),
  CONSTRAINT `FK_access_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10399 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_activityschedule`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_activityschedule` (
  `activityschedule_id` int(15) NOT NULL AUTO_INCREMENT,
  `staffactivity_id` int(15) NOT NULL DEFAULT '0',
  `staffschedule_id` int(15) NOT NULL DEFAULT '0',
  PRIMARY KEY (`activityschedule_id`),
  KEY `FK_activity_schedule` (`staffschedule_id`),
  KEY `FK_schedule_activity` (`staffactivity_id`),
  CONSTRAINT `FK_activity_schedule` FOREIGN KEY (`staffschedule_id`) REFERENCES `cim_hrdb_staffschedule` (`staffschedule_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_schedule_activity` FOREIGN KEY (`staffactivity_id`) REFERENCES `cim_hrdb_staffactivity` (`staffactivity_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=815 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_activitytype`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_activitytype` (
  `activitytype_id` int(10) NOT NULL AUTO_INCREMENT,
  `activitytype_desc` varchar(75) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `activitytype_abbr` varchar(6) COLLATE latin1_general_ci NOT NULL,
  `activitytype_color` varchar(7) COLLATE latin1_general_ci NOT NULL DEFAULT '#0000FF',
  PRIMARY KEY (`activitytype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_admin`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_admin` (
  `admin_id` int(1) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `priv_id` int(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_id`),
  KEY `FK_hrdbadmin_person` (`person_id`),
  KEY `FK_admin_priv` (`priv_id`),
  CONSTRAINT `FK_admin_priv` FOREIGN KEY (`priv_id`) REFERENCES `cim_hrdb_priv` (`priv_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_hrdbadmin_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_assignment`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_assignment` (
  `assignment_id` int(50) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `campus_id` int(50) NOT NULL DEFAULT '0',
  `assignmentstatus_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`assignment_id`),
  KEY `ciministry.cim_hrdb_assignment_person_id_index` (`person_id`),
  KEY `ciministry.cim_hrdb_assignment_campus_id_index` (`campus_id`),
  CONSTRAINT `FK_assign_campus` FOREIGN KEY (`campus_id`) REFERENCES `cim_hrdb_campus` (`campus_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_assign_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8372 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_assignmentstatus`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_assignmentstatus` (
  `assignmentstatus_id` int(10) NOT NULL AUTO_INCREMENT,
  `assignmentstatus_desc` varchar(64) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`assignmentstatus_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_campus`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_campus` (
  `campus_id` int(50) NOT NULL AUTO_INCREMENT,
  `campus_desc` varchar(128) NOT NULL DEFAULT '',
  `campus_shortDesc` varchar(50) NOT NULL DEFAULT '',
  `accountgroup_id` int(16) NOT NULL DEFAULT '0',
  `region_id` int(8) NOT NULL DEFAULT '0',
  `campus_website` varchar(128) NOT NULL DEFAULT '',
  `campus_facebookgroup` varchar(128) NOT NULL,
  `campus_gcxnamespace` varchar(128) NOT NULL,
  `province_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`campus_id`),
  KEY `ciministry.cim_hrdb_campus_region_id_index` (`region_id`),
  KEY `ciministry.cim_hrdb_campus_accountgroup_id_index` (`accountgroup_id`),
  CONSTRAINT `FK_campus_region` FOREIGN KEY (`region_id`) REFERENCES `cim_hrdb_region` (`region_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_campusadmin`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_campusadmin` (
  `campusadmin_id` int(20) NOT NULL AUTO_INCREMENT,
  `admin_id` int(20) NOT NULL DEFAULT '0',
  `campus_id` int(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`campusadmin_id`),
  KEY `ciministry.cim_hrdb_campusadmin_admin_id_index` (`admin_id`),
  KEY `ciministry.cim_hrdb_campusadmin_campus_id_index` (`campus_id`),
  CONSTRAINT `FK_campusadmin_campus` FOREIGN KEY (`campus_id`) REFERENCES `cim_hrdb_campus` (`campus_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_campus_hrdbadmin` FOREIGN KEY (`admin_id`) REFERENCES `cim_hrdb_admin` (`admin_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_country`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_country` (
  `country_id` int(50) NOT NULL AUTO_INCREMENT,
  `country_desc` varchar(50) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `country_shortDesc` varchar(50) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_customfields`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_customfields` (
  `customfields_id` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `report_id` int(10) unsigned NOT NULL,
  `fields_id` int(16) NOT NULL,
  PRIMARY KEY (`customfields_id`),
  KEY `FK_fields_report` (`report_id`),
  KEY `FK_report_field` (`fields_id`),
  CONSTRAINT `FK_fields_report` FOREIGN KEY (`report_id`) REFERENCES `cim_hrdb_customreports` (`report_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_report_field` FOREIGN KEY (`fields_id`) REFERENCES `cim_hrdb_fields` (`fields_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_customreports`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_customreports` (
  `report_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `report_name` varchar(64) COLLATE latin1_general_ci NOT NULL,
  `report_is_shown` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_emerg`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_emerg` (
  `emerg_id` int(16) NOT NULL AUTO_INCREMENT,
  `person_id` int(16) NOT NULL DEFAULT '0',
  `emerg_passportNum` varchar(32) NOT NULL DEFAULT '',
  `emerg_passportOrigin` varchar(32) NOT NULL DEFAULT '',
  `emerg_passportExpiry` date NOT NULL DEFAULT '0000-00-00',
  `emerg_contactName` varchar(64) NOT NULL DEFAULT '',
  `emerg_contactRship` varchar(64) NOT NULL DEFAULT '',
  `emerg_contactHome` varchar(32) NOT NULL DEFAULT '',
  `emerg_contactWork` varchar(32) NOT NULL DEFAULT '',
  `emerg_contactMobile` varchar(32) NOT NULL DEFAULT '',
  `emerg_contactEmail` varchar(32) NOT NULL DEFAULT '',
  `emerg_birthdate` date NOT NULL DEFAULT '0000-00-00',
  `emerg_medicalNotes` text NOT NULL,
  `emerg_contact2Name` varchar(64) NOT NULL,
  `emerg_contact2Rship` varchar(64) NOT NULL,
  `emerg_contact2Home` varchar(64) NOT NULL,
  `emerg_contact2Work` varchar(64) NOT NULL,
  `emerg_contact2Mobile` varchar(64) NOT NULL,
  `emerg_contact2Email` varchar(64) NOT NULL,
  `emerg_meds` text NOT NULL,
  `health_province_id` int(11) DEFAULT NULL,
  `health_number` varchar(255) DEFAULT NULL,
  `medical_plan_number` varchar(255) DEFAULT NULL,
  `medical_plan_carrier` varchar(255) DEFAULT NULL,
  `doctor_name` varchar(255) DEFAULT NULL,
  `doctor_phone` varchar(255) DEFAULT NULL,
  `dentist_name` varchar(255) DEFAULT NULL,
  `dentist_phone` varchar(255) DEFAULT NULL,
  `blood_type` varchar(255) DEFAULT NULL,
  `blood_rh_factor` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`emerg_id`),
  KEY `ciministry.cim_hrdb_emerg_person_id_index` (`person_id`),
  CONSTRAINT `FK_emerg_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3537 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_fieldgroup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_fieldgroup` (
  `fieldgroup_id` int(10) NOT NULL AUTO_INCREMENT,
  `fieldgroup_desc` varchar(75) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`fieldgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_fieldgroup_matches`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_fieldgroup_matches` (
  `fieldgroup_matches_id` int(20) NOT NULL AUTO_INCREMENT,
  `fieldgroup_id` int(10) NOT NULL DEFAULT '0',
  `fields_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`fieldgroup_matches_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_fields`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_fields` (
  `fields_id` int(16) NOT NULL AUTO_INCREMENT,
  `fieldtype_id` int(16) NOT NULL DEFAULT '0',
  `fields_desc` text NOT NULL,
  `staffscheduletype_id` int(15) NOT NULL DEFAULT '0',
  `fields_priority` int(16) NOT NULL DEFAULT '0',
  `fields_reqd` int(8) NOT NULL DEFAULT '0',
  `fields_invalid` varchar(128) NOT NULL DEFAULT '',
  `fields_hidden` int(8) NOT NULL DEFAULT '0',
  `datatypes_id` int(4) NOT NULL DEFAULT '0',
  `fieldgroup_id` int(10) NOT NULL DEFAULT '0',
  `fields_note` varchar(75) NOT NULL,
  PRIMARY KEY (`fields_id`),
  KEY `FK_fields_types2` (`fieldtype_id`),
  KEY `FK_fields_form` (`staffscheduletype_id`),
  KEY `FK_fields_dtype2` (`datatypes_id`),
  CONSTRAINT `FK_fields_dtype2` FOREIGN KEY (`datatypes_id`) REFERENCES `cim_reg_datatypes` (`datatypes_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fields_form` FOREIGN KEY (`staffscheduletype_id`) REFERENCES `cim_hrdb_staffscheduletype` (`staffscheduletype_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fields_types2` FOREIGN KEY (`fieldtype_id`) REFERENCES `cim_reg_fieldtypes` (`fieldtypes_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_fieldvalues`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_fieldvalues` (
  `fieldvalues_id` int(16) NOT NULL AUTO_INCREMENT,
  `fields_id` int(16) NOT NULL DEFAULT '0',
  `fieldvalues_value` text NOT NULL,
  `person_id` int(16) NOT NULL DEFAULT '0',
  `fieldvalues_modTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fieldvalues_id`),
  KEY `FK_fieldvals_person` (`person_id`),
  KEY `FK_fieldvals_field2` (`fields_id`),
  CONSTRAINT `FK_fieldvals_field2` FOREIGN KEY (`fields_id`) REFERENCES `cim_hrdb_fields` (`fields_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fieldvals_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1839 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_gender`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_gender` (
  `gender_id` int(50) NOT NULL AUTO_INCREMENT,
  `gender_desc` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`gender_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_ministry`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_ministry` (
  `ministry_id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `ministry_name` varchar(64) COLLATE latin1_general_ci NOT NULL,
  `ministry_abbrev` varchar(16) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`ministry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_person`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_person` (
  `person_id` int(50) NOT NULL AUTO_INCREMENT,
  `person_fname` varchar(50) NOT NULL DEFAULT '',
  `person_lname` varchar(50) NOT NULL DEFAULT '',
  `person_legal_fname` varchar(50) NOT NULL,
  `person_legal_lname` varchar(50) NOT NULL,
  `person_phone` varchar(50) NOT NULL DEFAULT '',
  `person_email` varchar(128) NOT NULL DEFAULT '',
  `person_addr` varchar(128) NOT NULL DEFAULT '',
  `person_city` varchar(50) NOT NULL DEFAULT '',
  `province_id` int(50) NOT NULL DEFAULT '0',
  `person_pc` varchar(50) NOT NULL DEFAULT '',
  `gender_id` int(50) NOT NULL DEFAULT '0',
  `person_local_phone` varchar(50) NOT NULL DEFAULT '',
  `person_local_addr` varchar(128) NOT NULL DEFAULT '',
  `person_local_city` varchar(50) NOT NULL DEFAULT '',
  `person_local_pc` varchar(50) NOT NULL DEFAULT '',
  `person_local_province_id` int(50) NOT NULL DEFAULT '0',
  `cell_phone` varchar(255) DEFAULT NULL,
  `local_valid_until` date DEFAULT NULL,
  `title_id` int(11) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `person_local_country_id` int(11) DEFAULT NULL,
  `person_mname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`person_id`),
  KEY `ciministry.cim_hrdb_person_gender_id_index` (`gender_id`),
  KEY `ciministry.cim_hrdb_person_province_id_index` (`province_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12559 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_person_year`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_person_year` (
  `personyear_id` int(50) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `year_id` int(50) NOT NULL DEFAULT '0',
  `grad_date` date DEFAULT '0000-00-00',
  PRIMARY KEY (`personyear_id`),
  KEY `FK_cim_hrdb_person_year` (`person_id`),
  KEY `1` (`year_id`),
  CONSTRAINT `1` FOREIGN KEY (`year_id`) REFERENCES `cim_hrdb_year_in_school` (`year_id`),
  CONSTRAINT `FK_year_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2946 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_priv`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_priv` (
  `priv_id` int(20) NOT NULL AUTO_INCREMENT,
  `priv_accesslevel` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`priv_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_province`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_province` (
  `province_id` int(50) NOT NULL AUTO_INCREMENT,
  `province_desc` varchar(50) NOT NULL DEFAULT '',
  `province_shortDesc` varchar(50) NOT NULL DEFAULT '',
  `country_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`province_id`)
) ENGINE=MyISAM AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_region`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_region` (
  `region_id` int(50) NOT NULL AUTO_INCREMENT,
  `reg_desc` varchar(64) NOT NULL DEFAULT '',
  `country_id` int(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`region_id`),
  KEY `FK_region_country` (`country_id`),
  CONSTRAINT `FK_region_country` FOREIGN KEY (`country_id`) REFERENCES `cim_hrdb_country` (`country_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_staff`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_staff` (
  `staff_id` int(50) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `is_active` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`staff_id`),
  KEY `ciministry.cim_hrdb_staff_person_id_index` (`person_id`),
  CONSTRAINT `FK_staff_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=357 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_staffactivity`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_staffactivity` (
  `staffactivity_id` int(15) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `staffactivity_startdate` date NOT NULL DEFAULT '0000-00-00',
  `staffactivity_enddate` date NOT NULL DEFAULT '0000-00-00',
  `staffactivity_contactPhone` varchar(20) COLLATE latin1_general_ci NOT NULL,
  `activitytype_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`staffactivity_id`),
  KEY `FK_activity_type` (`activitytype_id`),
  KEY `FK_activity_person` (`person_id`),
  CONSTRAINT `FK_activity_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_activity_type` FOREIGN KEY (`activitytype_id`) REFERENCES `cim_hrdb_activitytype` (`activitytype_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=818 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_staffdirector`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_staffdirector` (
  `staffdirector_id` int(60) unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` int(50) NOT NULL,
  `director_id` int(50) NOT NULL,
  PRIMARY KEY (`staffdirector_id`),
  KEY `FK_director_staff` (`director_id`),
  KEY `FK_staff_staff1` (`staff_id`),
  CONSTRAINT `FK_director_staff` FOREIGN KEY (`director_id`) REFERENCES `cim_hrdb_staff` (`staff_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_staff_staff1` FOREIGN KEY (`staff_id`) REFERENCES `cim_hrdb_staff` (`staff_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_staffschedule`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_staffschedule` (
  `staffschedule_id` int(15) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `staffscheduletype_id` int(15) NOT NULL DEFAULT '0',
  `staffschedule_approved` int(2) NOT NULL DEFAULT '0',
  `staffschedule_approvedby` int(50) NOT NULL DEFAULT '0',
  `staffschedule_lastmodifiedbydirector` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `staffschedule_approvalnotes` text COLLATE latin1_general_ci NOT NULL,
  `staffschedule_tonotify` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`staffschedule_id`),
  KEY `FK_schedule_type` (`staffscheduletype_id`),
  KEY `FK_schedule_person1` (`person_id`),
  CONSTRAINT `FK_schedule_person1` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_schedule_type` FOREIGN KEY (`staffscheduletype_id`) REFERENCES `cim_hrdb_staffscheduletype` (`staffscheduletype_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_staffscheduleinstr`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_staffscheduleinstr` (
  `staffscheduletype_id` int(15) NOT NULL,
  `staffscheduleinstr_toptext` text COLLATE latin1_general_ci NOT NULL,
  `staffscheduleinstr_bottomtext` text COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`staffscheduletype_id`),
  CONSTRAINT `FK_instr_schedtype` FOREIGN KEY (`staffscheduletype_id`) REFERENCES `cim_hrdb_staffscheduletype` (`staffscheduletype_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_staffscheduletype`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_staffscheduletype` (
  `staffscheduletype_id` int(15) NOT NULL AUTO_INCREMENT,
  `staffscheduletype_desc` varchar(75) COLLATE latin1_general_ci NOT NULL,
  `staffscheduletype_startdate` date NOT NULL DEFAULT '0000-00-00',
  `staffscheduletype_enddate` date NOT NULL DEFAULT '0000-00-00',
  `staffscheduletype_has_activities` int(2) NOT NULL DEFAULT '1',
  `staffscheduletype_has_activity_phone` int(2) NOT NULL DEFAULT '0',
  `staffscheduletype_activity_types` varchar(25) COLLATE latin1_general_ci NOT NULL,
  `staffscheduletype_is_shown` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`staffscheduletype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_title`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_title` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_hrdb_year_in_school`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_hrdb_year_in_school` (
  `year_id` int(11) NOT NULL AUTO_INCREMENT,
  `year_desc` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`year_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_activerules`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_activerules` (
  `pricerules_id` int(16) NOT NULL DEFAULT '0',
  `is_active` int(1) NOT NULL DEFAULT '0',
  `is_recalculated` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`pricerules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_campusaccess`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_campusaccess` (
  `campusaccess_id` int(16) NOT NULL AUTO_INCREMENT,
  `eventadmin_id` int(16) NOT NULL DEFAULT '0',
  `campus_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`campusaccess_id`)
) ENGINE=MyISAM AUTO_INCREMENT=217 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_cashtransaction`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_cashtransaction` (
  `cashtransaction_id` int(16) NOT NULL AUTO_INCREMENT,
  `reg_id` int(16) NOT NULL DEFAULT '0',
  `cashtransaction_staffName` varchar(64) NOT NULL DEFAULT '',
  `cashtransaction_recd` int(8) NOT NULL DEFAULT '0',
  `cashtransaction_amtPaid` float NOT NULL DEFAULT '0',
  `cashtransaction_moddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cashtransaction_id`),
  KEY `FK_cashtrans_reg` (`reg_id`),
  CONSTRAINT `FK_cashtrans_reg` FOREIGN KEY (`reg_id`) REFERENCES `cim_reg_registration` (`registration_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4821 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_ccreceipt`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_ccreceipt` (
  `ccreceipt_sequencenum` varchar(18) NOT NULL,
  `ccreceipt_authcode` varchar(8) DEFAULT NULL,
  `ccreceipt_responsecode` char(3) NOT NULL DEFAULT '',
  `ccreceipt_message` varchar(100) NOT NULL DEFAULT '',
  `ccreceipt_moddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cctransaction_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cctransaction_id`),
  CONSTRAINT `FK_receipt_cctrans` FOREIGN KEY (`cctransaction_id`) REFERENCES `cim_reg_cctransaction` (`cctransaction_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_cctransaction`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_cctransaction` (
  `cctransaction_id` int(16) NOT NULL AUTO_INCREMENT,
  `reg_id` int(16) NOT NULL DEFAULT '0',
  `cctransaction_cardName` varchar(64) NOT NULL DEFAULT '',
  `cctype_id` int(16) NOT NULL DEFAULT '0',
  `cctransaction_cardNum` text NOT NULL,
  `cctransaction_expiry` varchar(64) NOT NULL DEFAULT '',
  `cctransaction_billingPC` varchar(64) NOT NULL DEFAULT '',
  `cctransaction_processed` int(16) NOT NULL DEFAULT '0',
  `cctransaction_amount` float NOT NULL DEFAULT '0',
  `cctransaction_moddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cctransaction_refnum` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cctransaction_id`),
  KEY `FK_cctrans_reg` (`reg_id`),
  KEY `FK_cctrans_ccid` (`cctype_id`),
  CONSTRAINT `FK_cctrans_ccid` FOREIGN KEY (`cctype_id`) REFERENCES `cim_reg_cctype` (`cctype_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_cctrans_reg` FOREIGN KEY (`reg_id`) REFERENCES `cim_reg_registration` (`registration_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5174 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_cctype`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_cctype` (
  `cctype_id` int(16) NOT NULL AUTO_INCREMENT,
  `cctype_desc` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`cctype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_datatypes`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_datatypes` (
  `datatypes_id` int(4) NOT NULL AUTO_INCREMENT,
  `datatypes_key` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `datatypes_desc` varchar(64) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`datatypes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_event`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_event` (
  `event_id` int(50) NOT NULL AUTO_INCREMENT,
  `country_id` int(50) NOT NULL DEFAULT '0',
  `ministry_id` int(20) unsigned NOT NULL DEFAULT '0',
  `event_name` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `event_descBrief` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `event_descDetail` text CHARACTER SET latin1 NOT NULL,
  `event_startDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_endDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_regStart` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_regEnd` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_website` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `event_emailConfirmText` text CHARACTER SET latin1 NOT NULL,
  `event_basePrice` float NOT NULL DEFAULT '0',
  `event_deposit` float NOT NULL DEFAULT '0',
  `event_contactEmail` text CHARACTER SET latin1 NOT NULL,
  `event_pricingText` text CHARACTER SET latin1 NOT NULL,
  `event_onHomePage` int(1) NOT NULL DEFAULT '1',
  `event_allowCash` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_eventadmin`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_eventadmin` (
  `eventadmin_id` int(16) NOT NULL AUTO_INCREMENT,
  `event_id` int(16) NOT NULL DEFAULT '0',
  `priv_id` int(16) NOT NULL DEFAULT '0',
  `viewer_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`eventadmin_id`),
  KEY `FK_admin_event` (`event_id`),
  KEY `FK_admin_viewer` (`viewer_id`),
  KEY `FK_evadmin_priv` (`priv_id`),
  CONSTRAINT `FK_admin_event` FOREIGN KEY (`event_id`) REFERENCES `cim_reg_event` (`event_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_admin_viewer` FOREIGN KEY (`viewer_id`) REFERENCES `accountadmin_viewer` (`viewer_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_evadmin_priv` FOREIGN KEY (`priv_id`) REFERENCES `cim_reg_priv` (`priv_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=404 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_fields`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_fields` (
  `fields_id` int(16) NOT NULL AUTO_INCREMENT,
  `fieldtype_id` int(16) NOT NULL DEFAULT '0',
  `fields_desc` text NOT NULL,
  `event_id` int(16) NOT NULL DEFAULT '0',
  `fields_priority` int(16) NOT NULL DEFAULT '0',
  `fields_reqd` int(8) NOT NULL DEFAULT '0',
  `fields_invalid` varchar(128) NOT NULL DEFAULT '',
  `fields_hidden` int(8) NOT NULL DEFAULT '0',
  `datatypes_id` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`fields_id`),
  KEY `FK_fields_types` (`fieldtype_id`),
  KEY `FK_fields_event` (`event_id`),
  KEY `FK_fields_dtype` (`datatypes_id`),
  CONSTRAINT `FK_fields_dtype` FOREIGN KEY (`datatypes_id`) REFERENCES `cim_reg_datatypes` (`datatypes_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fields_event` FOREIGN KEY (`event_id`) REFERENCES `cim_reg_event` (`event_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fields_types` FOREIGN KEY (`fieldtype_id`) REFERENCES `cim_reg_fieldtypes` (`fieldtypes_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_fieldtypes`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_fieldtypes` (
  `fieldtypes_id` int(16) NOT NULL AUTO_INCREMENT,
  `fieldtypes_desc` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`fieldtypes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_fieldvalues`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_fieldvalues` (
  `fieldvalues_id` int(16) NOT NULL AUTO_INCREMENT,
  `fields_id` int(16) NOT NULL DEFAULT '0',
  `fieldvalues_value` text NOT NULL,
  `registration_id` int(16) NOT NULL DEFAULT '0',
  `fieldvalues_modTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fieldvalues_id`),
  KEY `FK_fieldvals_reg` (`registration_id`),
  KEY `FK_fieldvals_field` (`fields_id`),
  CONSTRAINT `FK_fieldvals_field` FOREIGN KEY (`fields_id`) REFERENCES `cim_reg_fields` (`fields_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fieldvals_reg` FOREIGN KEY (`registration_id`) REFERENCES `cim_reg_registration` (`registration_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45881 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_pricerules`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_pricerules` (
  `pricerules_id` int(16) NOT NULL AUTO_INCREMENT,
  `event_id` int(16) NOT NULL DEFAULT '0',
  `priceruletypes_id` int(16) NOT NULL DEFAULT '0',
  `pricerules_desc` text NOT NULL,
  `fields_id` int(10) NOT NULL DEFAULT '0',
  `pricerules_value` varchar(128) NOT NULL DEFAULT '',
  `pricerules_discount` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`pricerules_id`),
  KEY `FK_prules_event` (`event_id`),
  KEY `FK_prules_type` (`priceruletypes_id`),
  CONSTRAINT `FK_prules_event` FOREIGN KEY (`event_id`) REFERENCES `cim_reg_event` (`event_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_prules_type` FOREIGN KEY (`priceruletypes_id`) REFERENCES `cim_reg_priceruletypes` (`priceruletypes_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_priceruletypes`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_priceruletypes` (
  `priceruletypes_id` int(16) NOT NULL AUTO_INCREMENT,
  `priceruletypes_desc` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`priceruletypes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_priv`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_priv` (
  `priv_id` int(10) NOT NULL AUTO_INCREMENT,
  `priv_desc` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`priv_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_registration`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_registration` (
  `registration_id` int(50) NOT NULL AUTO_INCREMENT,
  `event_id` int(50) NOT NULL DEFAULT '0',
  `person_id` int(50) NOT NULL DEFAULT '0',
  `registration_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `registration_confirmNum` varchar(64) NOT NULL DEFAULT '',
  `registration_status` int(2) NOT NULL DEFAULT '0',
  `registration_balance` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`registration_id`),
  KEY `FK_reg_person` (`person_id`),
  KEY `FK_reg_status` (`registration_status`),
  CONSTRAINT `FK_reg_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_reg_status` FOREIGN KEY (`registration_status`) REFERENCES `cim_reg_status` (`status_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9542 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_scholarship`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_scholarship` (
  `scholarship_id` int(16) NOT NULL AUTO_INCREMENT,
  `registration_id` int(16) NOT NULL DEFAULT '0',
  `scholarship_amount` float NOT NULL DEFAULT '0',
  `scholarship_sourceAcct` varchar(64) NOT NULL DEFAULT '',
  `scholarship_sourceDesc` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`scholarship_id`),
  KEY `FK_scholarship_reg` (`registration_id`),
  CONSTRAINT `FK_scholarship_reg` FOREIGN KEY (`registration_id`) REFERENCES `cim_reg_registration` (`registration_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2271 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_status`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_status` (
  `status_id` int(10) NOT NULL,
  `status_desc` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_reg_superadmin`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_reg_superadmin` (
  `superadmin_id` int(16) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`superadmin_id`),
  KEY `FK_viewer_regsuperadmin` (`viewer_id`),
  CONSTRAINT `FK_viewer_regsuperadmin` FOREIGN KEY (`viewer_id`) REFERENCES `accountadmin_viewer` (`viewer_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_access`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_access` (
  `access_id` int(16) NOT NULL AUTO_INCREMENT,
  `staff_id` int(16) NOT NULL DEFAULT '0',
  `priv_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`access_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_coordinator`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_coordinator` (
  `coordinator_id` int(16) NOT NULL AUTO_INCREMENT,
  `access_id` int(16) NOT NULL DEFAULT '0',
  `campus_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`coordinator_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_exposuretype`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_exposuretype` (
  `exposuretype_id` int(10) NOT NULL AUTO_INCREMENT,
  `exposuretype_desc` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`exposuretype_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_month`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_month` (
  `month_id` int(10) NOT NULL AUTO_INCREMENT,
  `month_desc` varchar(64) NOT NULL DEFAULT '',
  `month_number` int(8) NOT NULL DEFAULT '0',
  `year_id` int(10) NOT NULL DEFAULT '0',
  `month_calendaryear` int(10) NOT NULL,
  `semester_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`month_id`)
) ENGINE=MyISAM AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_morestats`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_morestats` (
  `morestats_id` int(10) NOT NULL AUTO_INCREMENT,
  `morestats_exp` int(10) NOT NULL DEFAULT '0',
  `morestats_notes` text NOT NULL,
  `week_id` int(10) NOT NULL DEFAULT '0',
  `campus_id` int(10) NOT NULL DEFAULT '0',
  `exposuretype_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`morestats_id`)
) ENGINE=MyISAM AUTO_INCREMENT=579 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_prc`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_prc` (
  `prc_id` int(10) NOT NULL AUTO_INCREMENT,
  `prc_firstName` varchar(128) NOT NULL DEFAULT '',
  `prcMethod_id` int(10) NOT NULL DEFAULT '0',
  `prc_witnessName` varchar(128) NOT NULL DEFAULT '',
  `semester_id` int(10) NOT NULL DEFAULT '0',
  `campus_id` int(10) NOT NULL DEFAULT '0',
  `prc_notes` text NOT NULL,
  `prc_7upCompleted` int(10) NOT NULL DEFAULT '0',
  `prc_7upStarted` int(10) NOT NULL DEFAULT '0',
  `prc_date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`prc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=810 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_prcmethod`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_prcmethod` (
  `prcMethod_id` int(10) NOT NULL AUTO_INCREMENT,
  `prcMethod_desc` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`prcMethod_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_priv`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_priv` (
  `priv_id` int(16) NOT NULL AUTO_INCREMENT,
  `priv_desc` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`priv_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_semester`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_semester` (
  `semester_id` int(10) NOT NULL AUTO_INCREMENT,
  `semester_desc` varchar(64) NOT NULL DEFAULT '',
  `semester_startDate` date NOT NULL DEFAULT '0000-00-00',
  `year_id` int(8) NOT NULL DEFAULT '0',
  PRIMARY KEY (`semester_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_semesterreport`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_semesterreport` (
  `semesterreport_id` int(10) NOT NULL AUTO_INCREMENT,
  `semesterreport_avgPrayer` int(10) NOT NULL DEFAULT '0',
  `semesterreport_avgWklyMtg` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numStaffChall` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numInternChall` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numFrosh` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numStaffDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numInStaffDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numStudentDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numInStudentDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numSpMultStaffDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numSpMultStdDG` int(10) NOT NULL DEFAULT '0',
  `semester_id` int(10) NOT NULL DEFAULT '0',
  `campus_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`semesterreport_id`)
) ENGINE=MyISAM AUTO_INCREMENT=110 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_week`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_week` (
  `week_id` int(50) NOT NULL AUTO_INCREMENT,
  `week_endDate` date NOT NULL DEFAULT '0000-00-00',
  `semester_id` int(16) NOT NULL DEFAULT '0',
  `month_id` int(11) NOT NULL,
  PRIMARY KEY (`week_id`)
) ENGINE=MyISAM AUTO_INCREMENT=204 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_weeklyreport`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_weeklyreport` (
  `weeklyReport_id` int(10) NOT NULL AUTO_INCREMENT,
  `weeklyReport_1on1SpConv` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1GosPres` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1HsPres` int(10) NOT NULL DEFAULT '0',
  `staff_id` int(10) NOT NULL DEFAULT '0',
  `week_id` int(10) NOT NULL DEFAULT '0',
  `campus_id` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_7upCompleted` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1SpConvStd` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1GosPresStd` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1HsPresStd` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_7upCompletedStd` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_cjVideo` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_mda` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_otherEVMats` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_rlk` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_siq` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_notes` text NOT NULL,
  PRIMARY KEY (`weeklyReport_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7865 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cim_stats_year`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cim_stats_year` (
  `year_id` int(8) NOT NULL AUTO_INCREMENT,
  `year_desc` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`year_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `multi_gen_buttons`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `multi_gen_buttons` (
  `button_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT '0',
  `button_key` varchar(50) NOT NULL DEFAULT '',
  `button_value` varchar(50) NOT NULL DEFAULT '',
  `language_id` int(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`button_id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `multi_labels`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `multi_labels` (
  `labels_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `language_id` int(4) NOT NULL DEFAULT '0',
  `labels_key` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `labels_label` text CHARACTER SET latin1 NOT NULL,
  `labels_caption` text CHARACTER SET latin1,
  PRIMARY KEY (`labels_id`),
  KEY `page_id` (`page_id`),
  KEY `language_id` (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=26304 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `multi_languages`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `multi_languages` (
  `language_id` int(11) NOT NULL AUTO_INCREMENT,
  `language_label` varchar(128) NOT NULL DEFAULT '',
  `labels_key` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `multi_page`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `multi_page` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `series_id` int(11) NOT NULL DEFAULT '0',
  `page_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1685 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `multi_series`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `multi_series` (
  `series_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT '0',
  `series_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`series_id`)
) ENGINE=MyISAM AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `multi_site`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `multi_site` (
  `site_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_label` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`site_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `national_day`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `national_day` (
  `day_id` int(11) NOT NULL AUTO_INCREMENT,
  `day_date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`day_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2018 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `national_signup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `national_signup` (
  `signup_id` int(11) NOT NULL AUTO_INCREMENT,
  `day_id` int(11) NOT NULL DEFAULT '0',
  `time_id` int(11) NOT NULL DEFAULT '0',
  `signup_name` varchar(128) NOT NULL DEFAULT '',
  `campus_id` int(11) NOT NULL DEFAULT '0',
  `signup_email` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`signup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5111 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `national_time`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `national_time` (
  `time_id` int(11) NOT NULL AUTO_INCREMENT,
  `time_time` time NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (`time_id`)
) ENGINE=MyISAM AUTO_INCREMENT=241 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `national_timezones`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `national_timezones` (
  `timezones_id` int(11) NOT NULL AUTO_INCREMENT,
  `timezones_desc` varchar(32) NOT NULL DEFAULT '',
  `timezones_offset` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`timezones_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `navbar_navbarcache`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `navbar_navbarcache` (
  `navbarcache_id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) NOT NULL DEFAULT '0',
  `language_id` int(11) NOT NULL DEFAULT '0',
  `navbarcache_cache` text NOT NULL,
  `navbarcache_isValid` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`navbarcache_id`)
) ENGINE=MyISAM AUTO_INCREMENT=144927 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `navbar_navbargroup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `navbar_navbargroup` (
  `navbargroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `navbargroup_nameKey` varchar(50) NOT NULL DEFAULT '',
  `navbargroup_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`navbargroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `navbar_navbarlinks`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `navbar_navbarlinks` (
  `navbarlink_id` int(11) NOT NULL AUTO_INCREMENT,
  `navbargroup_id` int(11) NOT NULL DEFAULT '0',
  `navbarlink_textKey` varchar(50) NOT NULL DEFAULT '',
  `navbarlink_url` text NOT NULL,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `navbarlink_isActive` int(1) NOT NULL DEFAULT '0',
  `navbarlink_isModule` int(1) NOT NULL DEFAULT '0',
  `navbarlink_order` int(11) NOT NULL DEFAULT '0',
  `navbarlink_startDateTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `navbarlink_endDateTime` datetime NOT NULL DEFAULT '9999-12-29 23:59:00',
  PRIMARY KEY (`navbarlink_id`)
) ENGINE=MyISAM AUTO_INCREMENT=72 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `navbar_navlinkaccessgroup`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `navbar_navlinkaccessgroup` (
  `navlinkaccessgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `navbarlink_id` int(11) NOT NULL DEFAULT '0',
  `accessgroup_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`navlinkaccessgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=111 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `navbar_navlinkviewer`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `navbar_navlinkviewer` (
  `navlinkviewer_id` int(11) NOT NULL AUTO_INCREMENT,
  `navbarlink_id` int(11) NOT NULL DEFAULT '0',
  `viewer_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`navlinkviewer_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rad_dafield`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rad_dafield` (
  `dafield_id` int(11) NOT NULL AUTO_INCREMENT,
  `daobj_id` int(11) NOT NULL DEFAULT '0',
  `statevar_id` int(11) NOT NULL DEFAULT '-1',
  `dafield_name` varchar(50) NOT NULL DEFAULT '',
  `dafield_desc` text NOT NULL,
  `dafield_type` varchar(50) NOT NULL DEFAULT '',
  `dafield_dbType` varchar(50) NOT NULL DEFAULT '',
  `dafield_formFieldType` varchar(50) NOT NULL DEFAULT '',
  `dafield_isPrimaryKey` int(1) NOT NULL DEFAULT '0',
  `dafield_isForeignKey` int(1) NOT NULL DEFAULT '0',
  `dafield_isNullable` int(1) NOT NULL DEFAULT '0',
  `dafield_default` varchar(50) NOT NULL DEFAULT '',
  `dafield_invalidValue` varchar(50) NOT NULL DEFAULT '',
  `dafield_isLabelName` int(1) NOT NULL DEFAULT '0',
  `dafield_isListInit` int(1) NOT NULL DEFAULT '0',
  `dafield_isCreated` int(1) NOT NULL DEFAULT '0',
  `dafield_title` text NOT NULL,
  `dafield_formLabel` text NOT NULL,
  `dafield_example` text NOT NULL,
  `dafield_error` text NOT NULL,
  PRIMARY KEY (`dafield_id`)
) ENGINE=MyISAM AUTO_INCREMENT=359 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rad_daobj`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rad_daobj` (
  `daobj_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `daobj_name` varchar(50) NOT NULL DEFAULT '',
  `daobj_desc` text NOT NULL,
  `daobj_dbTableName` varchar(100) NOT NULL DEFAULT '',
  `daobj_managerInitVarID` int(11) NOT NULL DEFAULT '0',
  `daobj_listInitVarID` int(11) NOT NULL DEFAULT '0',
  `daobj_isCreated` int(1) NOT NULL DEFAULT '0',
  `daobj_isUpdated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`daobj_id`)
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rad_module`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rad_module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(50) NOT NULL DEFAULT '',
  `module_desc` text NOT NULL,
  `module_creatorName` text NOT NULL,
  `module_isCommonLook` int(1) NOT NULL DEFAULT '0',
  `module_isCore` int(1) NOT NULL DEFAULT '0',
  `module_isCreated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rad_page`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rad_page` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `page_name` varchar(50) NOT NULL DEFAULT '',
  `page_desc` text NOT NULL,
  `page_type` varchar(5) NOT NULL DEFAULT '',
  `page_isAdd` int(1) NOT NULL DEFAULT '0',
  `page_rowMgrID` int(11) NOT NULL DEFAULT '0',
  `page_listMgrID` int(11) NOT NULL DEFAULT '0',
  `page_isCreated` int(1) NOT NULL DEFAULT '0',
  `page_isDefault` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=123 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rad_pagefield`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rad_pagefield` (
  `pagefield_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `daobj_id` int(11) NOT NULL DEFAULT '0',
  `dafield_id` int(11) NOT NULL DEFAULT '0',
  `pagefield_isForm` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pagefield_id`)
) ENGINE=MyISAM AUTO_INCREMENT=433 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rad_pagelabels`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rad_pagelabels` (
  `pagelabel_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `pagelabel_key` varchar(50) NOT NULL DEFAULT '',
  `pagelabel_label` text NOT NULL,
  `language_id` int(11) NOT NULL DEFAULT '0',
  `pagelabel_isCreated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pagelabel_id`)
) ENGINE=MyISAM AUTO_INCREMENT=186 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rad_statevar`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rad_statevar` (
  `statevar_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `statevar_name` varchar(50) NOT NULL DEFAULT '',
  `statevar_desc` text NOT NULL,
  `statevar_type` enum('STRING','BOOL','INTEGER','DATE') NOT NULL DEFAULT 'STRING',
  `statevar_default` varchar(50) NOT NULL DEFAULT '',
  `statevar_isCreated` int(1) NOT NULL DEFAULT '0',
  `statevar_isUpdated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`statevar_id`)
) ENGINE=MyISAM AUTO_INCREMENT=97 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rad_transitions`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rad_transitions` (
  `transition_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `transition_fromObjID` int(11) NOT NULL DEFAULT '0',
  `transition_toObjID` int(11) NOT NULL DEFAULT '0',
  `transition_type` varchar(10) NOT NULL DEFAULT '',
  `transition_isCreated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`transition_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `site_logmanager`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_logmanager` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `log_userID` varchar(50) NOT NULL DEFAULT '',
  `log_dateTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `log_recipientID` varchar(50) NOT NULL DEFAULT '',
  `log_description` text NOT NULL,
  `log_data` text NOT NULL,
  `log_viewerIP` varchar(15) NOT NULL DEFAULT '',
  `log_applicationKey` varchar(4) NOT NULL DEFAULT '',
  PRIMARY KEY (`log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `site_multilingual_label`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_multilingual_label` (
  `label_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `label_key` varchar(50) NOT NULL DEFAULT '',
  `label_label` text NOT NULL,
  `label_moddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `language_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`label_id`),
  KEY `ciministry.site_multilingual_label_page_id_index` (`page_id`),
  KEY `ciministry.site_multilingual_label_label_key_index` (`label_key`),
  KEY `ciministry.site_multilingual_label_language_id_index` (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4646 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `site_multilingual_page`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_multilingual_page` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `series_id` int(11) NOT NULL DEFAULT '0',
  `page_key` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=304 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `site_multilingual_series`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_multilingual_series` (
  `series_id` int(11) NOT NULL AUTO_INCREMENT,
  `series_key` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`series_id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `site_multilingual_xlation`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_multilingual_xlation` (
  `xlation_id` int(11) NOT NULL AUTO_INCREMENT,
  `label_id` int(11) NOT NULL DEFAULT '0',
  `language_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`xlation_id`),
  KEY `language_id` (`language_id`),
  KEY `label_id` (`label_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5548 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `site_page_modules`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_page_modules` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_key` varchar(50) NOT NULL DEFAULT '',
  `module_path` text NOT NULL,
  `module_app` varchar(50) NOT NULL DEFAULT '',
  `module_include` varchar(50) NOT NULL DEFAULT '',
  `module_name` varchar(50) NOT NULL DEFAULT '',
  `module_parameters` text NOT NULL,
  `module_systemAccessFile` varchar(50) NOT NULL DEFAULT '',
  `module_systemAccessObj` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `site_session`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_session` (
  `session_id` varchar(32) NOT NULL DEFAULT '',
  `session_data` text NOT NULL,
  `session_expiration` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `temp_mb_early_frosh`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `temp_mb_early_frosh` (
  `registration_id` int(10) NOT NULL,
  PRIMARY KEY (`registration_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_comments`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_post_ID` int(11) NOT NULL DEFAULT '0',
  `comment_author` tinytext NOT NULL,
  `comment_author_email` varchar(100) NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT '0',
  `comment_approved` varchar(20) NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) NOT NULL DEFAULT '',
  `comment_type` varchar(20) NOT NULL DEFAULT '',
  `comment_parent` bigint(20) NOT NULL DEFAULT '0',
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`comment_ID`),
  KEY `comment_approved` (`comment_approved`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`)
) ENGINE=MyISAM AUTO_INCREMENT=40464 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_formbuilder_fields`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_formbuilder_fields` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `form_id` bigint(20) NOT NULL,
  `display_order` int(11) NOT NULL,
  `field_type` varchar(255) NOT NULL,
  `field_name` varchar(255) NOT NULL,
  `field_value` blob NOT NULL,
  `field_label` blob NOT NULL,
  `required_data` varchar(255) NOT NULL,
  `error_message` blob NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_formbuilder_forms`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_formbuilder_forms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` blob NOT NULL,
  `subject` blob NOT NULL,
  `recipient` blob NOT NULL,
  `method` enum('POST','GET') NOT NULL,
  `action` varchar(255) NOT NULL,
  `thankyoutext` blob NOT NULL,
  `autoresponse` bigint(20) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_formbuilder_pages`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_formbuilder_pages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL,
  `form_id` bigint(20) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_formbuilder_responses`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_formbuilder_responses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` blob NOT NULL,
  `subject` blob NOT NULL,
  `message` blob NOT NULL,
  `from_name` blob NOT NULL,
  `from_email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_links`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_links` (
  `link_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_name` varchar(255) NOT NULL DEFAULT '',
  `link_image` varchar(255) NOT NULL DEFAULT '',
  `link_target` varchar(25) NOT NULL DEFAULT '',
  `link_category` bigint(20) NOT NULL DEFAULT '0',
  `link_description` varchar(255) NOT NULL DEFAULT '',
  `link_visible` varchar(20) NOT NULL DEFAULT 'Y',
  `link_owner` int(11) NOT NULL DEFAULT '1',
  `link_rating` int(11) NOT NULL DEFAULT '0',
  `link_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_rel` varchar(255) NOT NULL DEFAULT '',
  `link_notes` mediumtext NOT NULL,
  `link_rss` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `link_category` (`link_category`),
  KEY `link_visible` (`link_visible`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_options`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_options` (
  `option_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `blog_id` int(11) NOT NULL DEFAULT '0',
  `option_name` varchar(64) NOT NULL DEFAULT '',
  `option_value` longtext NOT NULL,
  `autoload` varchar(20) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`,`blog_id`,`option_name`),
  KEY `option_name` (`option_name`)
) ENGINE=MyISAM AUTO_INCREMENT=381 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_postmeta`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_postmeta` (
  `meta_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL DEFAULT '0',
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`)
) ENGINE=MyISAM AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_posts`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) NOT NULL DEFAULT '0',
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_category` int(4) NOT NULL DEFAULT '0',
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(20) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` text NOT NULL,
  `post_parent` bigint(20) NOT NULL DEFAULT '0',
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT '0',
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`)
) ENGINE=MyISAM AUTO_INCREMENT=209 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_term_relationships`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_term_relationships` (
  `object_id` bigint(20) NOT NULL DEFAULT '0',
  `term_taxonomy_id` bigint(20) NOT NULL DEFAULT '0',
  `term_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_term_taxonomy`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_term_taxonomy` (
  `term_taxonomy_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) NOT NULL DEFAULT '0',
  `taxonomy` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `parent` bigint(20) NOT NULL DEFAULT '0',
  `count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_taxonomy_id`),
  UNIQUE KEY `term_id_taxonomy` (`term_id`,`taxonomy`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_terms`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_terms` (
  `term_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_usermeta`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_usermeta` (
  `umeta_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`)
) ENGINE=MyISAM AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_users`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `wp_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(64) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(60) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT '0',
  `display_name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-04-22  2:41:58

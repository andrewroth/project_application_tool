-- MySQL dump 10.13  Distrib 5.1.32, for apple-darwin9.5.0 (i386)
--
-- Host: localhost    Database: p2c_pat_prod
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
-- Table structure for table `airports`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `airports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country_code` varchar(255) DEFAULT NULL,
  `area_code` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `applns`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `applns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `preference1_id` int(11) DEFAULT NULL,
  `preference2_id` int(11) DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `as_intern` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `applns_form_id_index` (`form_id`),
  KEY `applns_viewer_id_index` (`viewer_id`),
  KEY `applns_preference1_id_index` (`preference1_id`),
  KEY `applns_preference2_id_index` (`preference2_id`),
  KEY `applns_as_intern_index` (`as_intern`)
) ENGINE=InnoDB AUTO_INCREMENT=3735 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cost_items`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cost_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `amount` decimal(8,2) DEFAULT NULL,
  `optional` tinyint(1) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `profile_id` int(11) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cost_items_type_index` (`type`),
  KEY `cost_items_year_index` (`year`),
  KEY `index_cost_items_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=601 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `countries`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `custom_element_required_sections`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `custom_element_required_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `element_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `attribute` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `donation_types`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `donation_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `donation_types_description_index` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `event_groups`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `event_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `location_type` varchar(255) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `long_desc` varchar(255) DEFAULT NULL,
  `default_text_area_length` int(11) DEFAULT '4000',
  `has_your_campuses` tinyint(1) DEFAULT NULL,
  `outgoing_email` varchar(255) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT '0',
  `content_type` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `show_mpdtool` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `eventgroup_coordinators`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `eventgroup_coordinators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `feedbacks`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) DEFAULT NULL,
  `feedback_type` text,
  `description` text,
  `created_at` datetime DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `feedbacks_viewer_id_index` (`viewer_id`),
  KEY `index_feedbacks_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_answers`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) DEFAULT NULL,
  `instance_id` int(11) DEFAULT NULL,
  `answer` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `form_answers_question_id_index` (`question_id`,`instance_id`),
  KEY `form_answers_instance_id_index` (`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=551959 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_element_flags`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_element_flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `element_id` int(11) DEFAULT NULL,
  `flag_id` int(11) DEFAULT NULL,
  `value` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_element_flags_element_id_index` (`element_id`),
  KEY `form_element_flags_flag_id_index` (`flag_id`),
  KEY `form_element_flags_value_index` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=3977 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_elements`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `text` text,
  `is_required` tinyint(1) DEFAULT NULL,
  `question_table` varchar(50) DEFAULT NULL,
  `question_column` varchar(50) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `dependency_id` int(11) DEFAULT NULL,
  `max_length` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `form_elements_parent_id_index` (`parent_id`),
  KEY `form_elements_type_index` (`type`),
  KEY `form_elements_position_index` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=29164 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_flags`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `element_txt` varchar(255) DEFAULT NULL,
  `group_txt` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_page_elements`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_page_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) DEFAULT NULL,
  `element_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_page_elements_page_id_index` (`page_id`),
  KEY `form_page_elements_element_id_index` (`element_id`),
  KEY `form_page_elements_position_index` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=12546 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_page_flags`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_page_flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) DEFAULT NULL,
  `flag_id` int(11) DEFAULT NULL,
  `value` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_page_flags_page_id_index` (`page_id`),
  KEY `form_page_flags_flag_id_index` (`flag_id`),
  KEY `form_page_flags_value_index` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=463 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_pages`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL,
  `url_name` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2282 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_question_options`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_question_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) DEFAULT NULL,
  `option` varchar(255) DEFAULT NULL,
  `value` varchar(50) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_question_options_question_id_index` (`question_id`),
  KEY `form_question_options_option_index` (`option`),
  KEY `form_question_options_value_index` (`value`),
  KEY `form_question_options_position_index` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=22191 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_questionnaire_pages`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_questionnaire_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questionnaire_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_questionnaire_pages_questionnaire_id_index` (`questionnaire_id`),
  KEY `form_questionnaire_pages_page_id_index` (`page_id`),
  KEY `form_questionnaire_pages_position_index` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=2282 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `form_reference_attributes`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `form_reference_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_id` int(11) DEFAULT NULL,
  `questionnaire_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `forms`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `questionnaire_id` int(11) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `forms_questionnaire_id_index` (`questionnaire_id`),
  KEY `index_forms_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `manual_donations`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `manual_donations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `motivation_code` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `donor_name` varchar(255) DEFAULT NULL,
  `donation_type_id` int(11) DEFAULT NULL,
  `original_amount` decimal(8,2) DEFAULT NULL,
  `amount` decimal(8,2) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `manual_donations_motivation_code_index` (`motivation_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2692 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `notification_acknowledgments`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `notification_acknowledgments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `notifications`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `controller` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `message` text,
  `begin_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `ignore_begin` tinyint(1) DEFAULT NULL,
  `ignore_end` tinyint(1) DEFAULT NULL,
  `no_hide_button` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `allow_html` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `optin_cost_items`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `optin_cost_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) DEFAULT NULL,
  `cost_item_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `optin_cost_items_profile_id_index` (`profile_id`),
  KEY `optin_cost_items_cost_item_id_index` (`cost_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1304 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `plugin_schema_info`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `preferences`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) DEFAULT NULL,
  `time_zone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `preferences_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prep_items`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `prep_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `deadline` date DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `individual` tinyint(1) DEFAULT '0',
  `deadline_optional` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prep_items_projects`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `prep_items_projects` (
  `prep_item_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `processor_forms`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `processor_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appln_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `processor_forms_appln_id_index` (`appln_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1689 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `processors`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `processors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `processors_project_id_index` (`project_id`),
  KEY `processors_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `profile_donations`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `profile_donations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `auto_donation_id` int(11) DEFAULT NULL,
  `manual_donation_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_donations_profile_id_index` (`profile_id`),
  KEY `profile_donations_type_index` (`type`),
  KEY `profile_donations_auto_donation_id_index` (`auto_donation_id`),
  KEY `profile_donations_manual_donation_id_index` (`manual_donation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84736 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `profile_notes`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `profile_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `profile_id` int(11) DEFAULT NULL,
  `creator_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `profile_prep_items`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `profile_prep_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) DEFAULT NULL,
  `prep_item_id` int(11) DEFAULT NULL,
  `submitted` tinyint(1) DEFAULT '0',
  `received` tinyint(1) DEFAULT '0',
  `notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `optional` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5353 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `profile_travel_segments`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `profile_travel_segments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) DEFAULT NULL,
  `travel_segment_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `eticket` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `confirmation_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_travel_segments_profile_id_index` (`profile_id`),
  KEY `profile_travel_segments_travel_segment_id_index` (`travel_segment_id`),
  KEY `profile_travel_segments_position_index` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=4352 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `profiles`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appln_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `support_coach_id` int(11) DEFAULT NULL,
  `support_claimed` float DEFAULT NULL,
  `accepted_by_viewer_id` int(11) DEFAULT NULL,
  `as_intern` tinyint(1) DEFAULT '0',
  `motivation_code` varchar(255) DEFAULT '0',
  `type` varchar(255) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `locked_by` int(11) DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `accepted_by` int(11) DEFAULT NULL,
  `accepted_at` datetime DEFAULT NULL,
  `withdrawn_by` int(11) DEFAULT NULL,
  `withdrawn_at` datetime DEFAULT NULL,
  `status_when_withdrawn` varchar(255) DEFAULT NULL,
  `class_when_withdrawn` varchar(255) DEFAULT NULL,
  `reason_id` int(11) DEFAULT NULL,
  `reason_notes` varchar(255) DEFAULT NULL,
  `support_claimed_updated_at` datetime DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `cached_costing_total` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profiles_appln_id_index` (`appln_id`),
  KEY `profiles_project_id_index` (`project_id`),
  KEY `profiles_support_coach_id_index` (`support_coach_id`),
  KEY `profiles_type_index` (`type`),
  KEY `profiles_viewer_id_index` (`viewer_id`),
  KEY `profiles_accepted_by_index` (`accepted_by`),
  KEY `profiles_locked_by_index` (`locked_by`),
  KEY `profiles_withdrawn_by_index` (`withdrawn_by`),
  KEY `profiles_reason_id_index` (`reason_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4455 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_administrators`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_administrators_project_id_index` (`project_id`),
  KEY `project_administrators_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_directors`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_directors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_directors_project_id_index` (`project_id`),
  KEY `project_directors_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_donations`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_donations` (
  `participant_motv_code` varchar(10) NOT NULL DEFAULT '',
  `participant_external_id` varchar(10) NOT NULL DEFAULT '',
  `donation_date` datetime DEFAULT '0000-00-00 00:00:00',
  `donation_reference_number` varchar(10) DEFAULT '',
  `donor_name` varchar(100) DEFAULT '',
  `donation_type` varchar(10) DEFAULT '',
  `original_amount` float DEFAULT '0',
  `amount` float DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `project_donations_participant_motv_code_index` (`participant_motv_code`)
) ENGINE=MyISAM AUTO_INCREMENT=22104 DEFAULT CHARSET=latin1 COMMENT='Truncated and re-loaded nightly by a DTS package on NUMBERS';
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_staffs`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_staffs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_staffs_project_id_index` (`project_id`),
  KEY `project_staffs_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=480 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `projects`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `start` date DEFAULT NULL,
  `end` date DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `cost_center` varchar(255) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_projects_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `projects_coordinators`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `projects_coordinators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `questionnaires`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `questionnaires` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=275 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `reason_for_withdrawals`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `reason_for_withdrawals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blurb` varchar(255) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reason_for_withdrawals_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `reference_emails`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `reference_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email_type` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `text` text,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reference_emails_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=685 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `reference_instances`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `reference_instances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `access_key` varchar(255) DEFAULT NULL,
  `email_sent_at` datetime DEFAULT NULL,
  `is_staff` tinyint(1) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `accountNo` varchar(255) DEFAULT NULL,
  `home_phone` varchar(255) DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `mail` tinyint(1) DEFAULT '0',
  `email_sent` tinyint(1) DEFAULT '0',
  `reference_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `appln_references_appln_id_index` (`instance_id`),
  KEY `appln_references_status_index` (`status`),
  KEY `appln_references_access_key_index` (`access_key`)
) ENGINE=InnoDB AUTO_INCREMENT=6643 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `report_elements`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `report_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `element_id` int(11) DEFAULT NULL,
  `report_model_method_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `heading` varchar(255) DEFAULT NULL,
  `cost_item_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1545 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `report_model_methods`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `report_model_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_model_id` int(11) DEFAULT NULL,
  `method_s` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `report_models`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `report_models` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_s` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `reports`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `include_accepted` tinyint(1) DEFAULT '1',
  `include_applying` tinyint(1) DEFAULT '0',
  `include_staff` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `schema_migrations`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sessions`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=184267 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `support_coaches`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `support_coaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `support_coaches_project_id_index` (`project_id`),
  KEY `support_coaches_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `taggings`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tagee_type` varchar(255) DEFAULT NULL,
  `tagee_id` int(11) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `taggings_tagee_type_index` (`tagee_type`),
  KEY `taggings_tagee_id_index` (`tagee_id`),
  KEY `taggings_tag_id_index` (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=916 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tags`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tags_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `travel_segments`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `travel_segments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `departure_city` varchar(255) DEFAULT NULL,
  `departure_time` datetime DEFAULT NULL,
  `carrier` varchar(255) DEFAULT NULL,
  `arrival_city` varchar(255) DEFAULT NULL,
  `arrival_time` datetime DEFAULT NULL,
  `flight_no` varchar(255) DEFAULT NULL,
  `notes` text,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `travel_segments_year_index` (`year`),
  KEY `travel_segments_departure_city_index` (`departure_city`),
  KEY `travel_segments_departure_time_index` (`departure_time`),
  KEY `travel_segments_carrier_index` (`carrier`),
  KEY `travel_segments_arrival_city_index` (`arrival_city`),
  KEY `travel_segments_arrival_time_index` (`arrival_time`),
  KEY `travel_segments_flight_no_index` (`flight_no`),
  KEY `index_travel_segments_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1205 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-04-22  2:42:06

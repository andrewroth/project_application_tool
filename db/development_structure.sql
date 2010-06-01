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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  KEY `applns_as_intern_index` (`as_intern`),
  KEY `applns_form_id_index` (`form_id`),
  KEY `applns_preference1_id_index` (`preference1_id`),
  KEY `applns_preference2_id_index` (`preference2_id`),
  KEY `applns_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  KEY `index_cost_items_on_event_group_id` (`event_group_id`),
  KEY `cost_items_type_index` (`type`),
  KEY `cost_items_year_index` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `custom_element_required_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `element_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `attribute` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `donation_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `donation_types_description_index` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `allows_multiple_applications_with_same_form` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `eventgroup_coordinators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) DEFAULT NULL,
  `feedback_type` text,
  `description` text,
  `created_at` datetime DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_feedbacks_on_event_group_id` (`event_group_id`),
  KEY `feedbacks_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `form_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) DEFAULT NULL,
  `instance_id` int(11) DEFAULT NULL,
  `answer` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `form_answers_question_id_index` (`question_id`,`instance_id`),
  KEY `form_answers_instance_id_index` (`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `form_element_flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `element_id` int(11) DEFAULT NULL,
  `flag_id` int(11) DEFAULT NULL,
  `value` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_element_flags_element_id_index` (`element_id`),
  KEY `form_element_flags_flag_id_index` (`flag_id`),
  KEY `form_element_flags_value_index` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  KEY `form_elements_position_index` (`position`),
  KEY `form_elements_type_index` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `form_flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `element_txt` varchar(255) DEFAULT NULL,
  `group_txt` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `form_page_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) DEFAULT NULL,
  `element_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_page_elements_element_id_index` (`element_id`),
  KEY `form_page_elements_page_id_index` (`page_id`),
  KEY `form_page_elements_position_index` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `form_page_flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) DEFAULT NULL,
  `flag_id` int(11) DEFAULT NULL,
  `value` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_page_flags_flag_id_index` (`flag_id`),
  KEY `form_page_flags_page_id_index` (`page_id`),
  KEY `form_page_flags_value_index` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `form_question_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) DEFAULT NULL,
  `option` varchar(256) DEFAULT NULL,
  `value` varchar(50) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_question_options_option_index` (`option`),
  KEY `form_question_options_position_index` (`position`),
  KEY `form_question_options_question_id_index` (`question_id`),
  KEY `form_question_options_value_index` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `form_questionnaire_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questionnaire_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_questionnaire_pages_page_id_index` (`page_id`),
  KEY `form_questionnaire_pages_position_index` (`position`),
  KEY `form_questionnaire_pages_questionnaire_id_index` (`questionnaire_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `form_reference_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_id` int(11) DEFAULT NULL,
  `questionnaire_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `questionnaire_id` int(11) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_forms_on_event_group_id` (`event_group_id`),
  KEY `forms_questionnaire_id_index` (`questionnaire_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `notification_acknowledgments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `optin_cost_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) DEFAULT NULL,
  `cost_item_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `optin_cost_items_cost_item_id_index` (`cost_item_id`),
  KEY `optin_cost_items_profile_id_index` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) DEFAULT NULL,
  `time_zone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `preferences_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `prep_items_projects` (
  `prep_item_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `processor_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appln_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `processor_forms_appln_id_index` (`appln_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `processors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `processors_project_id_index` (`project_id`),
  KEY `processors_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profile_donations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `auto_donation_id` int(11) DEFAULT NULL,
  `manual_donation_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_donations_auto_donation_id_index` (`auto_donation_id`),
  KEY `profile_donations_manual_donation_id_index` (`manual_donation_id`),
  KEY `profile_donations_profile_id_index` (`profile_id`),
  KEY `profile_donations_type_index` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profile_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `profile_id` int(11) DEFAULT NULL,
  `creator_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `profile_travel_segments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) DEFAULT NULL,
  `travel_segment_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `eticket` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `confirmation_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_travel_segments_position_index` (`position`),
  KEY `profile_travel_segments_profile_id_index` (`profile_id`),
  KEY `profile_travel_segments_travel_segment_id_index` (`travel_segment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `reuse_appln_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profiles_accepted_by_index` (`accepted_by`),
  KEY `profiles_appln_id_index` (`appln_id`),
  KEY `profiles_locked_by_index` (`locked_by`),
  KEY `profiles_project_id_index` (`project_id`),
  KEY `profiles_reason_id_index` (`reason_id`),
  KEY `profiles_support_coach_id_index` (`support_coach_id`),
  KEY `profiles_type_index` (`type`),
  KEY `profiles_viewer_id_index` (`viewer_id`),
  KEY `profiles_withdrawn_by_index` (`withdrawn_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_administrators_project_id_index` (`project_id`),
  KEY `project_administrators_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_directors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_directors_project_id_index` (`project_id`),
  KEY `project_directors_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_donations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_motv_code` varchar(10) NOT NULL DEFAULT '',
  `participant_external_id` varchar(10) NOT NULL DEFAULT '',
  `donation_date` datetime DEFAULT NULL,
  `donation_reference_number` varchar(10) DEFAULT '',
  `donor_name` varchar(100) DEFAULT '',
  `donation_type` varchar(10) DEFAULT '',
  `original_amount` float DEFAULT '0',
  `amount` float DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `project_donations_participant_motv_code_index` (`participant_motv_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_staffs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_staffs_project_id_index` (`project_id`),
  KEY `project_staffs_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `projects_coordinators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `questionnaires` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `reason_for_withdrawals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blurb` varchar(255) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reason_for_withdrawals_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `reference_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email_type` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `text` text,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reference_emails_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  KEY `appln_references_access_key_index` (`access_key`),
  KEY `appln_references_appln_id_index` (`instance_id`),
  KEY `appln_references_status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `report_model_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_model_id` int(11) DEFAULT NULL,
  `method_s` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `report_models` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_s` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `include_accepted` tinyint(1) DEFAULT '1',
  `include_applying` tinyint(1) DEFAULT '0',
  `include_staff` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `support_coaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `viewer_id` int(11) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `support_coaches_project_id_index` (`project_id`),
  KEY `support_coaches_viewer_id_index` (`viewer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tagee_type` varchar(255) DEFAULT NULL,
  `tagee_id` int(11) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `taggings_tag_id_index` (`tag_id`),
  KEY `taggings_tagee_id_index` (`tagee_id`),
  KEY `taggings_tagee_type_index` (`tagee_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tags_on_event_group_id` (`event_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  KEY `travel_segments_arrival_city_index` (`arrival_city`),
  KEY `travel_segments_arrival_time_index` (`arrival_time`),
  KEY `travel_segments_carrier_index` (`carrier`),
  KEY `travel_segments_departure_city_index` (`departure_city`),
  KEY `travel_segments_departure_time_index` (`departure_time`),
  KEY `index_travel_segments_on_event_group_id` (`event_group_id`),
  KEY `travel_segments_flight_no_index` (`flight_no`),
  KEY `travel_segments_year_index` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('100');

INSERT INTO schema_migrations (version) VALUES ('101');

INSERT INTO schema_migrations (version) VALUES ('102');

INSERT INTO schema_migrations (version) VALUES ('103');

INSERT INTO schema_migrations (version) VALUES ('104');

INSERT INTO schema_migrations (version) VALUES ('105');

INSERT INTO schema_migrations (version) VALUES ('106');

INSERT INTO schema_migrations (version) VALUES ('107');

INSERT INTO schema_migrations (version) VALUES ('108');

INSERT INTO schema_migrations (version) VALUES ('109');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('110');

INSERT INTO schema_migrations (version) VALUES ('111');

INSERT INTO schema_migrations (version) VALUES ('112');

INSERT INTO schema_migrations (version) VALUES ('113');

INSERT INTO schema_migrations (version) VALUES ('114');

INSERT INTO schema_migrations (version) VALUES ('115');

INSERT INTO schema_migrations (version) VALUES ('116');

INSERT INTO schema_migrations (version) VALUES ('117');

INSERT INTO schema_migrations (version) VALUES ('118');

INSERT INTO schema_migrations (version) VALUES ('119');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('120');

INSERT INTO schema_migrations (version) VALUES ('121');

INSERT INTO schema_migrations (version) VALUES ('122');

INSERT INTO schema_migrations (version) VALUES ('123');

INSERT INTO schema_migrations (version) VALUES ('124');

INSERT INTO schema_migrations (version) VALUES ('125');

INSERT INTO schema_migrations (version) VALUES ('126');

INSERT INTO schema_migrations (version) VALUES ('127');

INSERT INTO schema_migrations (version) VALUES ('128');

INSERT INTO schema_migrations (version) VALUES ('129');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('130');

INSERT INTO schema_migrations (version) VALUES ('131');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('16');

INSERT INTO schema_migrations (version) VALUES ('17');

INSERT INTO schema_migrations (version) VALUES ('18');

INSERT INTO schema_migrations (version) VALUES ('19');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20');

INSERT INTO schema_migrations (version) VALUES ('20080101010101');

INSERT INTO schema_migrations (version) VALUES ('20080101010102');

INSERT INTO schema_migrations (version) VALUES ('20080101010103');

INSERT INTO schema_migrations (version) VALUES ('20080101010104');

INSERT INTO schema_migrations (version) VALUES ('20080101010105');

INSERT INTO schema_migrations (version) VALUES ('20080101010106');

INSERT INTO schema_migrations (version) VALUES ('20080101010107');

INSERT INTO schema_migrations (version) VALUES ('20080101010108');

INSERT INTO schema_migrations (version) VALUES ('20080101010109');

INSERT INTO schema_migrations (version) VALUES ('20080101010110');

INSERT INTO schema_migrations (version) VALUES ('20080101010111');

INSERT INTO schema_migrations (version) VALUES ('20090101010101');

INSERT INTO schema_migrations (version) VALUES ('20090101010102');

INSERT INTO schema_migrations (version) VALUES ('20090101010103');

INSERT INTO schema_migrations (version) VALUES ('20090101010104');

INSERT INTO schema_migrations (version) VALUES ('20090101010105');

INSERT INTO schema_migrations (version) VALUES ('20090101010106');

INSERT INTO schema_migrations (version) VALUES ('20090101010107');

INSERT INTO schema_migrations (version) VALUES ('20090101010108');

INSERT INTO schema_migrations (version) VALUES ('20090102010101');

INSERT INTO schema_migrations (version) VALUES ('20090102010102');

INSERT INTO schema_migrations (version) VALUES ('20090102010103');

INSERT INTO schema_migrations (version) VALUES ('20090102010104');

INSERT INTO schema_migrations (version) VALUES ('20090102010105');

INSERT INTO schema_migrations (version) VALUES ('20090120044744');

INSERT INTO schema_migrations (version) VALUES ('20090120052126');

INSERT INTO schema_migrations (version) VALUES ('20090129213833');

INSERT INTO schema_migrations (version) VALUES ('20090129214108');

INSERT INTO schema_migrations (version) VALUES ('20090130205018');

INSERT INTO schema_migrations (version) VALUES ('20090131030011');

INSERT INTO schema_migrations (version) VALUES ('20090205164903');

INSERT INTO schema_migrations (version) VALUES ('20090205220010');

INSERT INTO schema_migrations (version) VALUES ('20090206162831');

INSERT INTO schema_migrations (version) VALUES ('20090211194433');

INSERT INTO schema_migrations (version) VALUES ('20090224210454');

INSERT INTO schema_migrations (version) VALUES ('20090225160126');

INSERT INTO schema_migrations (version) VALUES ('20090225192649');

INSERT INTO schema_migrations (version) VALUES ('20090227170135');

INSERT INTO schema_migrations (version) VALUES ('20090227173846');

INSERT INTO schema_migrations (version) VALUES ('20090311170722');

INSERT INTO schema_migrations (version) VALUES ('20090324195822');

INSERT INTO schema_migrations (version) VALUES ('20090602030150');

INSERT INTO schema_migrations (version) VALUES ('20090719234529');

INSERT INTO schema_migrations (version) VALUES ('20090916173113');

INSERT INTO schema_migrations (version) VALUES ('20100319192222');

INSERT INTO schema_migrations (version) VALUES ('20100511211337');

INSERT INTO schema_migrations (version) VALUES ('20100525193338');

INSERT INTO schema_migrations (version) VALUES ('21');

INSERT INTO schema_migrations (version) VALUES ('22');

INSERT INTO schema_migrations (version) VALUES ('23');

INSERT INTO schema_migrations (version) VALUES ('24');

INSERT INTO schema_migrations (version) VALUES ('25');

INSERT INTO schema_migrations (version) VALUES ('26');

INSERT INTO schema_migrations (version) VALUES ('27');

INSERT INTO schema_migrations (version) VALUES ('28');

INSERT INTO schema_migrations (version) VALUES ('29');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('30');

INSERT INTO schema_migrations (version) VALUES ('31');

INSERT INTO schema_migrations (version) VALUES ('32');

INSERT INTO schema_migrations (version) VALUES ('33');

INSERT INTO schema_migrations (version) VALUES ('35');

INSERT INTO schema_migrations (version) VALUES ('36');

INSERT INTO schema_migrations (version) VALUES ('37');

INSERT INTO schema_migrations (version) VALUES ('38');

INSERT INTO schema_migrations (version) VALUES ('39');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('40');

INSERT INTO schema_migrations (version) VALUES ('41');

INSERT INTO schema_migrations (version) VALUES ('42');

INSERT INTO schema_migrations (version) VALUES ('43');

INSERT INTO schema_migrations (version) VALUES ('44');

INSERT INTO schema_migrations (version) VALUES ('45');

INSERT INTO schema_migrations (version) VALUES ('46');

INSERT INTO schema_migrations (version) VALUES ('47');

INSERT INTO schema_migrations (version) VALUES ('48');

INSERT INTO schema_migrations (version) VALUES ('49');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('51');

INSERT INTO schema_migrations (version) VALUES ('52');

INSERT INTO schema_migrations (version) VALUES ('53');

INSERT INTO schema_migrations (version) VALUES ('54');

INSERT INTO schema_migrations (version) VALUES ('55');

INSERT INTO schema_migrations (version) VALUES ('56');

INSERT INTO schema_migrations (version) VALUES ('57');

INSERT INTO schema_migrations (version) VALUES ('58');

INSERT INTO schema_migrations (version) VALUES ('59');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('60');

INSERT INTO schema_migrations (version) VALUES ('61');

INSERT INTO schema_migrations (version) VALUES ('62');

INSERT INTO schema_migrations (version) VALUES ('63');

INSERT INTO schema_migrations (version) VALUES ('64');

INSERT INTO schema_migrations (version) VALUES ('65');

INSERT INTO schema_migrations (version) VALUES ('66');

INSERT INTO schema_migrations (version) VALUES ('67');

INSERT INTO schema_migrations (version) VALUES ('68');

INSERT INTO schema_migrations (version) VALUES ('69');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('70');

INSERT INTO schema_migrations (version) VALUES ('71');

INSERT INTO schema_migrations (version) VALUES ('72');

INSERT INTO schema_migrations (version) VALUES ('73');

INSERT INTO schema_migrations (version) VALUES ('74');

INSERT INTO schema_migrations (version) VALUES ('75');

INSERT INTO schema_migrations (version) VALUES ('76');

INSERT INTO schema_migrations (version) VALUES ('77');

INSERT INTO schema_migrations (version) VALUES ('78');

INSERT INTO schema_migrations (version) VALUES ('79');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('80');

INSERT INTO schema_migrations (version) VALUES ('81');

INSERT INTO schema_migrations (version) VALUES ('82');

INSERT INTO schema_migrations (version) VALUES ('83');

INSERT INTO schema_migrations (version) VALUES ('84');

INSERT INTO schema_migrations (version) VALUES ('85');

INSERT INTO schema_migrations (version) VALUES ('86');

INSERT INTO schema_migrations (version) VALUES ('87');

INSERT INTO schema_migrations (version) VALUES ('88');

INSERT INTO schema_migrations (version) VALUES ('89');

INSERT INTO schema_migrations (version) VALUES ('9');

INSERT INTO schema_migrations (version) VALUES ('90');

INSERT INTO schema_migrations (version) VALUES ('91');

INSERT INTO schema_migrations (version) VALUES ('92');

INSERT INTO schema_migrations (version) VALUES ('93');

INSERT INTO schema_migrations (version) VALUES ('94');

INSERT INTO schema_migrations (version) VALUES ('95');

INSERT INTO schema_migrations (version) VALUES ('96');

INSERT INTO schema_migrations (version) VALUES ('97');

INSERT INTO schema_migrations (version) VALUES ('98');

INSERT INTO schema_migrations (version) VALUES ('99');
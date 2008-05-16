class AddLotsOfIndexes < ActiveRecord::Migration
  @table_columns = { 
    'ciministry.accountadmin_accesscategory' => [ :accesscategory_key ],
    'ciministry.accountadmin_accessgroup' => [ :accesscategory_id, :accessgroup_key ],
    'ciministry.accountadmin_accountadminaccess' => [ :viewer_id, :accountadminaccess_privilege ],
    'ciministry.accountadmin_accessgroup' => [ :accessgroup_key ],
    'ciministry.accountadmin_viewer' => [ :accountgroup_id, :viewer_userID ],
    'ciministry.accountadmin_vieweraccessgroup' => [ :viewer_id, :accessgroup_id ],
    'ciministry.cim_hrdb_assignment' => [ :person_id, :campus_id ],
    'ciministry.cim_hrdb_access' => [ :viewer_id, :person_id ],
    'ciministry.cim_hrdb_person' => [ :gender_id, :campus_id, :province_id ],
    'ciministry.cim_hrdb_campus' => [ :region_id, :accountgroup_id ],
    'ciministry.cim_hrdb_campusadmin' => [ :admin_id, :campus_id ],
    'ciministry.cim_hrdb_emerg' => [ :person_id ],
    'ciministry.cim_hrdb_staff' => [ :person_id ],
    'ciministry.site_multilingual_label' => [ :page_id, :label_key, :language_id ],
    :appln_references => [ :appln_id, :type, :status, :access_key ],
    :applns => [ :form_id, :viewer_id, :status, :preference1_id, :preference2_id, :as_intern ],
    :cost_items => [ :type, :year ],
    :donation_types => [ :description ],
    :feedbacks => [ :viewer_id ],
    :form_answers => [ :question_id, :instance_id ],
    :form_element_flags => [ :element_id, :flag_id, :value ],
    :form_elements => [ :parent_id, :type, :position  ],
    :form_page_elements => [ :page_id, :element_id, :position ],
    :form_page_flags => [ :page_id, :flag_id, :value ],
    :form_question_options => [ :question_id, :option, :value, :position ],
    :form_questionnaire_pages => [ :questionnaire_id, :page_id, :position ],
    :forms => [ :questionnaire_id ],
    :manual_donations => [ :motivation_code ],
    :optin_cost_items => [ :profile_id, :cost_item_id ],
    :preferences => [ :viewer_id ],
    :processor_forms => [ :appln_id ],
    :processor_piles => [ :appln_id, :project_id, :locked_by_viewer_id ],
    :processors => [ :project_id, :viewer_id ],
    :profile_donations => [ :profile_id, :type, :auto_donation_id, :manual_donation_id ],
    :profile_travel_segments => [ :profile_id, :travel_segment_id, :position ],
    :profile_travel_segments => [ :profile_id, :travel_segment_id, :position ],
    :profiles => [ :appln_id, :project_id, :support_coach_id, :type, :viewer_id ],
    :project_administrators => [ :project_id, :viewer_id ],
    :project_directors => [ :project_id, :viewer_id ],
    :project_donations => [ :participant_motv_code ],
    :project_staffs => [ :project_id, :viewer_id ],
    :support_coaches => [ :project_id, :viewer_id ],
    :taggings => [ :tagee_type, :tagee_id, :tag_id ],
    :travel_segments => [ :year, :departure_city, :departure_time, :carrier, :arrival_city, :arrival_time, :flight_no ],
  }
  
  def self.up    
    @table_columns.each_pair do |k,vs|
      for v in vs
        begin
          params = {}
          params[:unique] = true if v == :id

          name = k.to_s + '_' + v.to_s
          max = 50
          params[:name] = name[0,max] if name.length > max

          add_index k, v, params
        rescue
          puts $! if $!.to_s['Duplicate key name'].nil?
        end
      end
      
      begin
        execute "CREATE INDEX travel_segments_notes ON travel_segments (notes(10));"
        execute "CREATE INDEX feedbacks_feedback_type ON feedbacks (feedback_type(10));"      
      rescue
        puts $! if $!.to_s['Duplicate key name'].nil?
      end
    end
  end

  def self.down
  end
end

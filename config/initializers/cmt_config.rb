module Cmt
  CONFIG = {
    # Allow GCX logins in the form on the CMT login page.
    :gcx_direct_logins => true,

    # Allow local user logins in the form on the CMT login page.
    :local_direct_logins => true,

    # Allow GCX logins using the GCX login page (aka the greenscreen).
    # This will show a link on the login page.  If the direct GCX or
    # local logins are also allowed, both the form and link will be
    # displayed.
    :gcx_greenscreen_directly => false,
    
    # Show gcx connexion bar
    :gcx_connexion_bar => true,

    # Show the login page with a link back to the greenscreen.
    # Note: Don't set both gcx_greenscreen_directly and gcx_greenscreen_from_link true.
    :gcx_greenscreen_from_link => true,
    
    # Disable GCX Import functionality
    :gcx_import_disabled => false,

    # Forces users to go through a longer process for validating accounts.
    # Note used yet.
    :full_account_verification => true,
    
    # Removes the options of specifying 'poor' timeslots in timetable
    :hide_poor_status_in_scheduler => true,
    
    # Default ministry name
    :default_ministry_name => 'Campus for Christ',
    
    # When set, the campus filter is disabled and all 
    # campuses from this country are displayed
    # Set to nil(:campus_scope_country => nil) to disable.
    :campus_scope_country => nil,

    # The default country to select on all the country dropdowns
    :default_country => 'United States',

    # Disable second address line
    :disable_address2 => false,
    
    # Default website title appearing at the top of the browser
    :web_title => 'Campus for Christ :: Movement Tracker',

    # When no Permission object is found for a controller/action,
    # does the user have permission
    :permissions_granted_by_default => true,
    
    # When true, hides timetable impact dropdown in group_types form
    :disable_group_timetable_impact => true,
    
    # When enabled, users will be able to use the 'find common times' algorithim when making groups
    :find_common_times_enabled => true,
    
    # All staff can edit any student's timetable in their ministry
    :staff_can_edit_student_timetables => false,
    
    # When enabled, training items and catergories will be shown and can be editted by users
    :training_enabled => true,
    
    # When enabled, leadership notes can be editted and view on someone's profile when the user has permission
    :leadership_notes_enabled => true,
    
    # When enabled, involvement questions will appear as a tab in profiles and also in the customize area
    :involvement_questions_enabled => true,
    
    # When enabled, users can connect their CMT profile to that of their facebook
    :facebook_connectivity_enabled => false,
    
    # When enabled, users can edit profile pictures on their profile
    :profile_picture_enabled => true,
    
    # When enabled, large buttons for 'join a group' and 'edit your timetable' will appear in the dashboard
    :dashboard_big_buttons_enabled => true,

    # prefix to preprend to the subject of each email going out
    :email_subject_prefix => "[MT] ",

    # the from address for each outgoing email
    :email_from_address => "noreply@ministrytracker.org"
  }
end


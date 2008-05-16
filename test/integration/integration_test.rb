require "#{File.dirname(__FILE__)}/../test_helper"

class IntegrationTest < ActionController::IntegrationTest
  fixtures "ciministry/accountadmin_viewer"
  fixtures :applns, :forms, :projects
  fixtures "questionnaire_engine/questionnaires"
  fixtures "questionnaire_engine/form_pages"
  fixtures "questionnaire_engine/form_questionnaire_pages"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_vieweraccessgroup"
  
  def test_student
    # not sure why this isn't done automatically..
    Ticket.delete_all
  
    new_session("john.calvin") do |calvin_student|
      calvin_student.goes_to_login
      calvin_student.goes_through_cim
      
      calvin_student.assert_template "your_apps/list"
#      calvin_student.output_html_response
      
    end
  end
  
  private
  
    module MyTestingDSL
      include TestHelper
      def set_viewer(viewer_userID)
        @viewer = Viewer.find_by_viewer_userID(viewer_userID)
      end
      
      def goes_to_login
        get "/"
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template "security/login"
      end
      
      def goes_through_cim
        # make a ticket pretending to be the cim
        Ticket.create :viewer_id => @viewer.viewer_id,
          :ticket_ticket => "password",
          :ticket_expiry => Time.now + 60 * 60 # 1 hour
        
        get "/security/login", { :ticket => "password" }
        assert_response :redirect
	follow_redirect! # to scope eventgroup
        get set_as_scope_event_group_url(1)
        follow_redirect! # to main
        assert_response :redirect
        follow_redirect! # to student index
        assert_response :redirect
        follow_redirect! # to student list
        assert_response :success
      end
      
#      def signs_up_with(options)
#        post "/signup", options
#        assert_response :redirect
#        follow_redirect!
#        assert_response :success
#        assert_template "ledger/index"
#      end
    end
    
    def new_session(viewer_userID)
      open_session do |sess|
        sess.extend(MyTestingDSL)
        sess.set_viewer(viewer_userID)
        yield sess if block_given?
      end
    end
end

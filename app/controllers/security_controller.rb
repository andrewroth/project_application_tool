require 'soap/wsdlDriver'
require 'soap/mapping'
require 'defaultDriver'

class SecurityController < ApplicationController
  require 'digest/md5'
  filter_parameter_logging :password
  
  skip_before_filter :restrict_students
  skip_before_filter :set_user
  skip_before_filter :get_appln
  skip_before_filter :ensure_projects_app_created
  skip_before_filter :verify_event_group_chosen
  skip_before_filter :set_event_group

  before_filter :ensure_gcx_in_session, :only => [ :link_gcx, :do_link_gcx, :link_gcx_new, :do_link_gcx_new ]

  # makes a new viewer and person and links them to the gcx logged in
  def do_link_gcx
    result = login_by_cim
    if result[:keep_trying]
      result[:error] = "Sorry, couldn't find an intranet user '#{params[:username]}'"
    end

    if result[:error]
      flash[:notice] = result[:error]
      redirect_to :action => 'link_gcx'
      return
    end

    v = Viewer.find result[:viewer_id]
    v.guid = session[:gcx][:guid]
    v.save!

    flash[:notice] = "Connected intranet user '#{params[:username]}' with gcx user '#{session[:gcx][:email]}'"
    flash.keep

    setup_given_viewer_id v.id
  end

  def do_link_gcx_new
    v = Viewer.create :guid => session[:gcx][:guid], :viewer_lastLogin => 0, :accountgroup_id => 15, :viewer_userID => params[:email]
    p = Person.create :person_fname => params[:first_name], :person_lname => params[:last_name]
    Access.create :viewer_id => v.id, :person_id => p.id

    flash[:notice] = "Account created."
    flash.keep
    setup_given_viewer_id v.id
  end

  def link_gcx
    redirect_to(:action => 'login') if session[:gcx].nil?

    flash.delete :gcx # this should be done from the last page, but doesn't seem to clear it..
    flash[:link] = "Congratulations, your GCX login worked!  There's just one more step.  We need to link GCX logins to the old intranet/project tool logins.  You only need to do this once.  If you don't have an intranet login, <A HREF='/security/link_gcx_new'>click here</A>.<BR /><BR />Please log in now the old way."
    @show_contact_emails_override = true
  end

  def link_gcx_new
    flash[:gcx] = "The following fields are required to make an intranet login."
    @show_contact_emails_override = true
  end

  def index
    login
  end
  
  def read_login_message_confirm
    #if ['1', 1, 'true', true].include? params[:read_motd]
    #  session[:needs_read_login_message_confirm] = false
      redirect_to :controller => :main, :action => 'index'
    #else
    #  flash[:notice] = "For legal reasons, we need you to indicate that you've actually read this login message."
    #  render :action => 'motd'
    #end
  end
  
  def login
    flash[:gcx] = "[6/19/2008] You can now use your GCX email and password to log in."
    return unless params[:username]

    result = login_by_ticket
    result = login_by_gcx if result[:keep_trying]
    result = login_by_cim if result[:keep_trying]

    if result[:error]
      flash[:notice] = result[:error]
      return
    elsif result[:gcx_no_viewer]
      redirect_to :action => 'link_gcx'
    else
      setup_given_viewer_id result[:viewer_id]
    end      
  end

  def login_by_ticket
    return { :keep_trying => true } unless params[:ticket]

    ticket = Ticket.find_by_ticket_ticket(ticket_str)

    if ticket && ticket.viewer_id
      session[:login_source] = 'intranet'
      { :viewer_id => ticket.viewer_id }
    else
      { :error => "Sorry, that ticket (#{params[:ticket]}) is invalid."}
    end
  end

  def login_by_cim
    return { :keep_trying => true } unless params[:username] && params[:password]

    login_viewer = Viewer.find_by_viewer_userID params[:username]
    return { :keep_trying => true } unless login_viewer

    hash_pass = Digest::MD5.hexdigest(params[:password])
    if hash_pass == login_viewer.viewer_passWord || (RAILS_ENV == 'development' && params[:password] == 'secret123')
      session[:login_source] = 'spt'

      # if the secret password was used, we want to reset the session, since 
      # automated tests will use this and they will want to set the eg id
      if (RAILS_ENV == 'development' && params[:password] == 'secret123')
        cookies[:event_group_id] = nil
        session[:event_group_id] = nil
      end

      { :viewer_id => login_viewer.id }
    else
      { :error => "Sorry, that password is incorrect." }
    end
    
  end

  def login_by_gcx
     # look for a gcx guid
     cas = TntWareSSOProviderSoap.new
     return_to = request.protocol + request.host_with_port # apparently this doesn't matter, but this looks like a good value
     remote_ip = request.remote_ip # apparently this doesn't matter, but this looks like a good value
     args = GetServiceTicketFromUserNamePassword.new(return_to, params[:username], params[:password], remote_ip)

     # A little debug code can save the day
     log = ''
     cas.wiredump_dev = log
     begin
       ticket = cas.getServiceTicketFromUserNamePassword(args).getServiceTicketFromUserNamePasswordResult
     rescue
       # Auth failed
       return { :error => "Sorry, authentication failed for '#{params[:username]}'" }
     end

     args = GetSsoUserFromServiceTicket.new(return_to, ticket)
     # A little debug code can save the day
     log = ''
     cas.wiredump_dev = log
     begin
       user = cas.getSsoUserFromServiceTicket(args).getSsoUserFromServiceTicketResult
     rescue
       return { :error => "Sorry, failed getting user information from gcx for '#{params[:username]}'" }
     end

     viewer = Viewer.find_by_guid user.userID
     session[:gcx] = { :ticket => ticket, :firstName => user.firstName, :lastName => user.lastName, :guid => user.userID, :email => user.email }

     if viewer
       session[:login_source] = 'gcx'
       return { :viewer_id => viewer.id }
     else
       return { :gcx_no_viewer => true }
     end
   end

  def login_old
    if (params[:ticket])
    elsif (params[:username] && params[:password])
      login_viewer = Viewer.find_by_viewer_userID params[:username]

      hash_pass = Digest::MD5.hexdigest(params[:password])
      if hash_pass == login_viewer.viewer_passWord || (RAILS_ENV == 'development' && params[:password] == 'secret123')
        @user = User.new(login_viewer.id)
        session[:login_source] = 'spt'
	
	# if the secret password was used, we want to reset the session, since 
	# automated tests will use this and they will want to set the eg id
	if (RAILS_ENV == 'development' && params[:password] == 'secret123')
	  cookies[:event_group_id] = nil
	  session[:event_group_id] = nil
	end
	
      else
        flash[:notice] = "Sorry, that password is incorrect."
      end
    elsif session[:user_id]
      # they've already logged in??
      @user = User.new session[:user_id]

      if !(session[:login_source] == 'spt' &&
                   @user.is_student? && session[:needs_read_login_message_confirm])
        redirect_to :controller => "main"
        return
      end
    end

    # Save the userid and redirect to root if they're logged in.
    if (@user)
      session[:user_id] = @user.id
      
      logger.debug(@user.inspect)
      flash[:downtime] ||= "<br />There will be two short periods of downtime (approx 10 mins each) sometime before 9:30 AM EST (6:30 PST) on Tuesday Jan 22, 2007 for maintenance"
      
      #if session[:login_source] == 'spt' && @user.is_student?
      #  session[:needs_read_login_message_confirm] = true
      #  redirect_to :action => :motd
      #else
      #  session[:needs_read_login_message_confirm] = false
        redirect_to :controller => "main"
      #end
    end
  end
  
  def logout
    @user = nil
    session[:user_id] = nil
    session[:needs_read_login_message_confirm] = true

    if session[:login_source] == 'intranet'
      redirect_to $cim_url
    else
      flash[:notice] = "You have been logged out."
      redirect_to :action => :login
    end
  end
  
  protected

  def setup_given_viewer_id(viewer_id)
    @user = User.new(viewer_id)

    session[:user_id] = @user.id
    session[:gcx] = nil

    # if the secret password was used, we want to reset the session, since
    # automated tests will use this and they will want to set the eg id
    if (RAILS_ENV == 'development' && params[:password] == 'secret123')
      cookies[:event_group_id] = nil
      session[:event_group_id] = nil
    end

    logger.debug('login ' + @user.inspect)

    #flash[:downtime] ||= "<br />There will be two short periods of downtime (approx 10 mins each) sometime before 9:30 AM EST (6:30 PST) on Tuesday Jan 22, 2007 for maintenance"
      
    redirect_to :controller => "main"
  end

  def ensure_gcx_in_session
    unless session[:gcx]
      flash[:error] = "Error: No gcx info found in session."
      redirect_to :action => :login
    end
  end
end

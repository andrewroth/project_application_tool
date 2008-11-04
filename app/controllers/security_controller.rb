require 'soap/wsdlDriver'
require 'soap/mapping'
require 'defaultDriver'

class SecurityController < ApplicationController
  require 'digest/md5'
  filter_parameter_logging :password
  
  skip_before_filter :restrict_students
  skip_before_filter :set_user, :except => [ :test_rescues_path ]
  skip_before_filter :get_appln
  skip_before_filter :ensure_projects_app_created
  skip_before_filter :verify_event_group_chosen
  skip_before_filter :set_event_group

  before_filter :ensure_gcx_in_session, :only => [ :link_gcx, :do_link_gcx, :link_gcx_new, :do_link_gcx_new ]

  # makes a new viewer and person and links them to the gcx logged in
  def do_link_gcx
    result = login_by_cim
    if result[:keep_trying]
      result[:error] = "Sorry, couldn't find an intranet user '#{params[:username]}'.  Please try again."
    end

    if result[:error]
      flash[:notice] = result[:error]
      redirect_to :action => 'link_gcx'
      return
    end

    v = Viewer.find result[:viewer_id]
    if v.guid && !v.guid.empty? && v.guid != session[:gcx][:guid]
      flash[:notice] = "Error: Account '#{params[:username]}' already linked with a different gcx account."
      redirect_to :action => 'link_gcx'
      return
    end

    v.guid = session[:gcx][:guid]
    v.save!

    flash[:notice] = "Connected intranet user '#{params[:username]}' with gcx user '#{session[:gcx][:email]}'.  Now you can log in with your gcx user."
    flash.keep

    setup_given_viewer_id v.id
  end

  def do_link_gcx_new
    v = Viewer.create :guid => session[:gcx][:guid], :viewer_lastLogin => 0, :accountgroup_id => 15, :viewer_userID => params[:email]
    p = Person.create :person_fname => params[:first_name], :person_lname => params[:last_name]
    ag_st = Accessgroup.find_by_accessgroup_key '[accessgroup_student]'
    Vieweraccessgroup.create :viewer_id => v.id, :accessgroup_id => ag_st.id
    Access.create :viewer_id => v.id, :person_id => p.id

    flash[:notice] = "Account created."
    flash.keep
    setup_given_viewer_id v.id
  end

  def link_gcx
    redirect_to(:action => 'login') if session[:gcx].nil?

    flash.delete :gcx
    flash[:link] = "Congratulations, your GCX login worked!  There's just one more step.  We need to link GCX logins to the old intranet/project tool logins.  You only need to do this once.  If you don't have an intranet login, click the link below. Otherwise please log in now the old way."
    @show_contact_emails_override = true
  end

  def link_gcx_new
    flash[:gcx] = "That's ok -- we just need the following information."
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
  
  def signup
  end

  def login
    if is_demo_host
      student_str = "- To demo a student filling out an application, use the username 'student' and password 'student'"
      processor_str = "- To demo a processor deciding whether to accept or decline a student, use the username 'processor' and password 'processor'"
      admin_str = "- To demo an admin with access to configure applications, set up mission trips, etc., use the username 'admin' and password 'admin'"

      if params[:demo] == 'student'
        flash[:demo] = student_str
      elsif params[:demo] == 'processor'
        flash[:demo] = processor_str
      elsif params[:demo] == 'admin'
        flash[:demo] = admin_str
      else
        flash[:demo] = "#{student_str}\n#{processor_str}\n#{admin_str}"
      end
    end

    return unless params[:username]

    # props to Waterloo project
    if params[:username] == 'stupid ninja game time'
      e = (' '*(rand(30)+10)).split('').collect { |c| rand() < 0.8 ? '!' : '1' }.join
      options = [ "BOOOOOOM SUCKAAAAAAA!!!!!#{e}", "Sooooooonic BOOOOOOOOOOM!!!#{e}******", "Beat you with a stick!!#{e}", "bust u up!!!!!!!!!!!#{e}", 
          "AUuuugh Auuuurrgh Auuuuuuuugh!!#{e}! <ripping heart out>", "Proooteiiiin RAAAAAAAGGGGE!!!1!1!#{e}", "blessed.", 
          "AAAAAAAAAAAAAAAAAAAUGH#{e} <breaks neck>", "AAAAaaaaaaah!#{e} <rabid squirrel>" ]
      i = rand(options.length)
      s = options[i]
      flash[:stupidninjagame] = s
      return
    end

    result = login_by_ticket
    result = login_by_gcx if result[:keep_trying]
    result = login_by_cim if result[:keep_trying]

    result[:error] = "Sorry, authentication failed for '#{params[:username]}'" if result[:keep_trying]
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
      logger.debug "ticket login succeeded for #{params[:username]}"
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

      logger.debug "cim login succeeded for #{params[:username]}"
      { :viewer_id => login_viewer.id }
    else
      { :error => "Sorry, that password is incorrect." }
    end
    
  end

  def login_by_gcx
    # look for a gcx guid
    cas = TntWareSSOProviderSoap.new
    return_to = request.protocol + request.host
    remote_ip = request.remote_ip # apparently this doesn't matter, but this looks like a good value
    args = GetServiceTicketFromUserNamePassword.new(return_to, params[:username], params[:password], remote_ip)

    # A little debug code can save the day
    log = ''
    cas.wiredump_dev = log
    begin
      ticket = cas.getServiceTicketFromUserNamePassword(args).getServiceTicketFromUserNamePasswordResult
    rescue
      # Auth failed
      return { :keep_trying => true }
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
      logger.debug "gcx login succeeded for #{params[:username]}"

      return { :viewer_id => viewer.id }
    else
      return { :gcx_no_viewer => true }
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
  
  def test_rescues_path
    render :inline => "doesn't exist test: #{rescues_path('doesntexist')} exists test: #{rescues_path('layout')}"
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

  def is_demo_host
    request.host['demo']
  end
end

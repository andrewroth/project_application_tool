class SecurityController < ApplicationController
  require 'digest/md5'
  filter_parameter_logging :password
  
  skip_before_filter :restrict_students
  skip_before_filter :set_user
  skip_before_filter :get_appln
  skip_before_filter :ensure_projects_app_created
  skip_before_filter :verify_event_group_chosen
  skip_before_filter :set_event_group

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
    if (params[:ticket])
      @user = get_access(params[:ticket])

      if nil == @user 
        flash[:notice] = "Sorry, that ticket (#{params[:ticket]}) is invalid."
      else
        session[:login_source] = 'intranet'
      end
    elsif (params[:username] && params[:password])
      login_viewer = Viewer.find_by_viewer_userID params[:username]
      if !login_viewer
        flash[:notice] = "Sorry, no account with username #{params[:username]} exists."
        return
      end
      
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
  
  # returns a User object corresponding to the ticket or nil if the
  # ticket is invalid
  def get_access(ticket_str)
    # find ticket
    ticket = Ticket.find_by_ticket_ticket(ticket_str)
    return nil unless ticket
    
    # make user
    return User.new(ticket.viewer_id)
  end
end

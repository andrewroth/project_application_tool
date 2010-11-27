class SecurityController < ApplicationController
  require 'digest/md5'
  filter_parameter_logging :password
  
  skip_before_filter :restrict_students
  skip_before_filter :set_user, :except => [ :test_rescues_path ]
  skip_before_filter :get_appln
  skip_before_filter :ensure_projects_app_created
  skip_before_filter :verify_event_group_chosen
  skip_before_filter :set_event_group

  before_filter CASClient::Frameworks::Rails::GatewayFilter, :only => :login

  before_filter :ensure_gcx_in_session, :only => [ :link_gcx, :do_link_gcx, :link_gcx_new, :do_link_gcx_new ]

  # makes a new viewer and person and links them to the gcx logged in
  def do_link_gcx
    result = login_by_cim
    if result[:keep_trying]
      flash[:notice] = "Sorry, couldn't find an intranet user '#{params[:username]}'.  Please try again."
      redirect_to :action => 'link_gcx', :try_again => true
      return
    end

    if result[:error]
      flash[:notice] = result[:error]
      redirect_to :action => 'link_gcx', :try_again => true, :username => params[:username]
      return
    end

    v = Viewer.find result[:viewer_id]
    if v.guid && !v.guid.empty? && v.guid != cas_sso_guid
      flash[:notice] = "Error: Account '#{params[:username]}' already linked with a different gcx account."
      logger.info "Link GCX Error: Account '#{params[:username]}' already linked with a different gcx account.  viewer id: #{v.id} guid: #{v.guid} cas guid: #{cas_sso_guid} session: #{session.inspect}"
      redirect_to :action => 'link_gcx', :try_again => true, :username => params[:username]

      return
    end

    v.guid = cas_sso_guid
    v.save!

    flash[:notice] = "Connected old user '#{params[:username]}' with gcx user '#{session[:cas_user]}'.  Now you can log in with your gcx user."
    flash.keep

    setup_given_viewer_id v.id
  end

  def cas_sso_guid
    session[:cas_extra_attributes]['ssoGuid'] || 
      session[:cas_extra_attributes]['sso_guid']
  end

  def cas_last_name
    session[:cas_extra_attributes]['lastName'] || 
      session[:cas_extra_attributes]['last_name']
  end

  def cas_first_name
    session[:cas_extra_attributes]['firstName'] || 
      session[:cas_extra_attributes]['first_name']
  end

  def do_link_gcx_new
    v = Viewer.find_or_create_from_cas session[:cas_last_valid_ticket]

    setup_given_viewer_id v.id
  end

  def link_gcx
    flash.delete :gcx
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

    # props to Waterloo project
    if params[:username] && params[:username] == 'stupid ninja game time'
      e = (' '*(rand(30)+10)).split('').collect { |c| rand() < 0.8 ? '!' : '1' }.join
      options = [ "BOOOOOOM SUCKAAAAAAA!!!!!#{e}", "Sooooooonic BOOOOOOOOOOM!!!#{e}******", "Beat you with a stick!!#{e}", "bust u up!!!!!!!!!!!#{e}", 
          "AUuuugh Auuuurrgh Auuuuuuuugh!!#{e}! <ripping heart out>", "Proooteiiiin RAAAAAAAGGGGE!!!1!1!#{e}", "blessed.", 
          "AAAAAAAAAAAAAAAAAAAUGH#{e} <breaks neck>", "AAAAaaaaaaah!#{e} <rabid squirrel>" ]
      i = rand(options.length)
      s = options[i]
      flash[:stupidninjagame] = s
      return
    end

    clear_login_session_info

    result = login_by_gcx
    result = login_by_cim if result[:keep_trying]

    if result[:error]
      flash[:notice] = result[:error]
    elsif result[:gcx_no_viewer]
      redirect_to :action => 'link_gcx'
    elsif !result[:keep_trying]
      setup_given_viewer_id result[:viewer_id]
    end

    # give a warning about intranet logins expiring
    if session[:login_source] == 'spt'
      flash[:notice] = "Sorry, intranet logins are not supported any more.  Use GCX instead."
      clear_login_session_info
      logger.info "Intranet login closed @ #{Time.now} - viewer #{@viewer.viewer_userID} id #{@viewer.id}"
    end

  end

  def login_by_cim
    return { :keep_trying => true } unless params[:username] && params[:password] && params[:password] != ''

    begin
      login_viewer = Viewer.find_by_viewer_userID params[:username]
    rescue NoMethodError => e
      # bizarre error, happens randomly.  try again
      Viewer.reset_column_information
      login_viewer = Viewer.find :first, :conditions => { Viewer._(:user_name) => params[:username] }
    end

    return { :error => "Username '#{params[:username]}' doesn't exist.", :keep_trying => true } unless login_viewer

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
    return { :keep_trying => true } unless session[:cas_user]

    begin
      viewer = User.find_or_create_from_cas(session[:cas_last_valid_ticket])
    rescue NoMethodError => e
      # try the darned thing again..
      Viewer.reset_column_information
      viewer = User.find_or_create_from_cas(session[:cas_last_valid_ticket])
    end

    if viewer
      session[:login_source] = 'gcx'
      logger.debug "gcx login succeeded for #{session[:cas_user]}"

      return { :viewer_id => viewer.id }
    else
      return { :gcx_no_viewer => true }
    end
  end
 
  def logout
    if session[:login_source] == 'intranet'
      redirect_to $cim_url
    elsif session[:login_source] == 'gcx'
      redirect_to CASClient::Frameworks::Rails::Filter.client.logout_url
    elsif session[:login_source] == 'impersonate'
      session[:user_id] = session[:viewer_before_impersonate]
      session[:login_source] = session[:login_source_before_impersonate]
      redirect_to :controller => 'main'
      return
    end

    clear_login_session_info
    clear_cas_session
    @viewer = nil

    flash[:notice] = "You have been logged out."
  end
  
  def test_rescues_path
    render :inline => "doesn't exist test: #{rescues_path('doesntexist')} exists test: #{rescues_path('layout')}"
  end

  protected

  def clear_login_session_info
    session[:user_id] = nil
    session[:needs_read_login_message_confirm] = true
    session[:login_source] = nil
  end

  def clear_cas_session
    session[:user_id] = nil
    session[:needs_read_login_message_confirm] = true
    session[:cas_user] = nil
  end

  def setup_given_viewer_id(viewer_id)
    @viewer = Viewer.find viewer_id

    session[:user_id] = @viewer.id
    session[:gcx] = nil

    # if the secret password was used, we want to reset the session, since
    # automated tests will use this and they will want to set the eg id
    if (RAILS_ENV == 'development' && params[:password] == 'secret123')
      cookies[:event_group_id] = nil
      session[:event_group_id] = nil
    end

    logger.debug('login ' + @viewer.inspect)


    if @viewer
      if @viewer.respond_to?(:login_callback)
        @viewer.login_callback
      end
      @viewer.last_login = Time.now
      @viewer.username = session[:casfilteruser]
      @viewer.save!
    end

    redirect_to :controller => "main"
  end

  def ensure_gcx_in_session
    #unless session[:cas_user]
    #  flash[:error] = "Error: No gcx info found in session."
    #  redirect_to :action => :login
    #end
  end

  def is_demo_host
    request.host['demo']
  end
end

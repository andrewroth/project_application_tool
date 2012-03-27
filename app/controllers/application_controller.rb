require_dependency 'custom_pages'
require_dependency 'custom_elements'

# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  if RAILS_ENV == 'production'
    $server_url = "https://pat.powertochange.org"
  else
    $server_url = "http://dev.spt.campusforchrist.org"
  end

  $cim_url = "http://intranet.campusforchrist.org"
  $sp_email_only = 'projects@campusforchrist.org'
  $sp_email = "Power to Change Projects <#{$sp_email_only}>"
  $tech_email_only = 'pat.help@powertochange.org'
  
  # let's just sweep everything, it's easier :P
  cache_sweeper :profiles_sweeper

  # Ensures that the user came from the campus intranet to
  # the login page.
  before_filter :verify_user, :except => [ :logout, :login, :motd, :read_login_message_confirm, 
                                           :link_gcx, :do_link_gcx, :link_gcx_new, :do_link_gcx_new, :signup, 
                                           :test_rescues_path ]
  
  # create the session object from the db
  before_filter :set_user


  # ensure they've chosen a project group for the session
  before_filter :verify_event_group_chosen
  before_filter :set_event_group

  before_filter :get_profile_and_appln
  
  # ensure students only go to the students page
  before_filter :restrict_students
  
  # sets whether the user can see your projects page
  before_filter :set_show_your_projects
  
  before_filter :set_pdf
  after_filter :output_pdf_if_requested

  # don't use a layout on ajax requests
  layout :only_when_not_ajax_or_printing

  after_filter :no_cache

  before_filter :get_notifications

  protected

  # prevent Internet Explorer from caching Ajax GET request with Cache-Control:
  #  "max-age=0, private, must-revalidate"
  # suggested cache-conrol from Nik's comment:
  #   http://blog.innerewut.de/2007/9/22/ie-doesn-t-let-us-rest
  # IE does obey the standard Cache-Control: no-cache (Rails default) on Ajax POST or non-Ajax requests
  def no_cache
    if request.xhr? && request.get?
      expires_in 0, {'must-revalidate' => true}  # expires_in also sets as 'private'
    end
  end

  def set_pdf() @pdf = params[:print] == 'pdf'; @for_pdf = params[:for_pdf]; true end

  def output_pdf_if_requested
    return true if !@pdf

    generator = IO.popen("htmldoc -t pdf --path \".;http://#{request.env["HTTP_HOST"]}\" --webpage -", "w+")
    generator.puts response.body
    generator.close_write

    send_data(generator.read, :filename => "#{params[:filename] || params[:action]}.pdf", :type => "application/pdf")
    true
  end

  def only_when_not_ajax_or_printing
    request.xml_http_request? ? false : (
      if ['true','pdf', true].include?(params[:print]) then 'print'
      else 'application'
      end
    )
  end
  
  def verify_user
    #if session[:needs_read_login_message_confirm]
    #  redirect_to :controller => "security", :action => "motd"
    #elsif (session[:user_id].nil?)
    if (session[:user_id].nil?)
      session[:url_to_redirect_when_logged_in] = request.path
      redirect_to :controller => "security", :action => "login"
      return false
    end
    return true
  end
  
  def set_user
    if session[:user_id]
      @viewer = Viewer.find session[:user_id]
      render(:inline => "Missing person for viewer #{@viewer.id}") if @viewer.person.nil?
    else
      @viewer = nil
    end
  end

  # note: no security done here because you might actually have people looking at applications
  # that aren't theirs, for example processors; permissions are checked elsewhere though in their
  # respective contorllers/actions
  def get_profile_and_appln
    begin
      if params[:profile_id]
        @profile = Profile.find(params[:profile_id], :include => :appln)
        @appln = @profile.appln
        @project = @profile.project
        
        if params[:appln_id] && @appln.id.to_s != params[:appln_id]
          render :inline => "Error: requested appln (#{params[:appln_id]}) doesn't match requested profile's appln (#{@appln.id})"
        end
      end

      @pass_params ||= {}
      @pass_params[:profile_id] = @profile.id if @profile
      @pass_params[:id] ||= @profile.id if @profile # to support map.resources
    rescue
      @appln = nil
    end
  end
  
  def restrict_students
    if (@viewer && @viewer.is_student?(@eg))
      if @viewer.is_any_project_staff(@eg)
      else
        redirect_to :controller => "your_apps"
      end
    end
  end
  
  def set_show_your_projects
    @show_your_project = @viewer && (!@viewer.is_student?(@eg) || @viewer.is_any_project_staff(@eg))
    true
  end
  
  # --------- project group ----------
  def verify_event_group_chosen
    session[:event_group_id] = cookies[:event_group_id] if cookies[:event_group_id]
    
    unless session[:event_group_id] && !EventGroup.find(:all).empty? && 
            !(session[:event_group_id].class == String && session[:event_group_id].empty?)
      flash.keep :notice
      redirect_to scope_event_groups_url
    end 
  end

  def set_event_group
    begin
      @eg = EventGroup.find session[:event_group_id] if !EventGroup.find(:all).empty?
      session[:logo_url] = @eg.logo unless session[:logo_url]
    rescue  
      session[:event_group_id] = nil
      session[:logo_url] = nil
      redirect_to :action => params[:action]
      false
    end
  end

  def debug_eval(s)
    puts "#{s}: #{eval(s)}"
  end

  def get_notifications
    # match controller
    @notifications = Notification.find_all_by_controller [ '*', '', params[:controller] ]
    @notifications += Notification.find_all_by_controller nil # this needs to be its own call apaprently

    @notifications.delete_if { |n| 
      if n.premature? || n.expired?
        true
      elsif n.matches_controller?(params[:controller]) && n.matches_action?(params[:action])
        # matches controller and action, delete only if acknowledged
        @viewer && @viewer && @viewer.notification_acknowledgments.find_by_notification_id(n.id)
      else
        true
      end
    }
  end

  def parse_date_from_hash(hash, key)
    i1 = hash.delete "#{key.to_s}(1i)"
    i2 = hash.delete "#{key.to_s}(2i)"
    i3 = hash.delete "#{key.to_s}(3i)"
    if i1 && i2 && i3
      hash[key.to_sym] = Date.new(i1, i2, i3)
    end
  end

  def brand_link(link)
    if link.include? "?"
      link << "&"
    else
      link << "?"
    end
    #link << "template=https://d15ip9v2bx8xzx.cloudfront.net/media/sso/p2c_style.css"
    if @eg && @eg.key_logo_url
      link << "template=#{$server_url}/event_groups/#{@eg.id}/custom_css.css?v=#{Digest::MD5.hexdigest(@eg.key_logo_url)}"
    end
    link.gsub("login?", "login.htm?")
  end
  helper_method :brand_link

end

require_dependency 'lib/add_datetime_extended_new.rb'

class ToolsController < ApplicationController
  before_filter :ensure_eventgroup_coordinator
  before_filter :set_title
  before_filter :get_manual_donations_from_criteria, :only => 
    [ :convert_block_set_manual_donation_rate, :preview_block_set_manual_donation_rate ]
  
  def convert_block_set_manual_donation_rate
    @new_conversion_rate = params[:rate].to_f
    @uid = Time.now.to_i

    @nc = 0
    for m in @manual_donations
      m.conversion_rate = @new_conversion_rate
      m.amount = m.original_amount.to_f * m.conversion_rate.to_f
      m.status = params[:set_status]
      m.save!
      @nc += 1
    end
  end

  def block_set_manual_donation_rate
  end

  def preview_block_set_manual_donation_rate
    start_date = DateTime.new_from_hash params[:start]
    end_date = DateTime.new_from_hash params[:end]

    @new_conversion_rate = params[:rate].to_f

    # profiles
    all_profiles = Profile.find_all_by_motivation_code @manual_donations.collect(&:motivation_code)
    @profiles = {} # hash of motivation code -> profile for that motv code
    for p in all_profiles
      @profiles[p.motivation_code] = p
    end

    # totals
    @totals = { :curr_amount => 0, :curr_final => 0, :new_final => 0 }
    for d in @manual_donations
      @totals[:curr_amount] += d.original_amount
      @totals[:curr_final] += d.amount
      d.new_final = d.original_amount.to_f * @new_conversion_rate
      @totals[:new_final] += d.new_final
    end

  end

  def update_motivation_codes
    # all root nodes, for populating the switch eg dropdown
    @all_nodes = EventGroup.roots
    @all_event_group_titles = [ ]
    @all_event_group_titles << [ "all", "all" ]
    @all_event_group_titles += Node.roots_to_dropdown_list :roots => @all_nodes

    # set some defaults
    unless request.post?
      params[:event_group_id] ||= @eg.id
      params[:include_accepted] ||= '1'
      params[:include_withdrawn] ||= '1'
      params[:include_staff] ||= '1'
      params[:include_with_codes] ||= '0'
      params[:include_without_codes] ||= '1'
    end

    profile_types = []
    profile_types << "Accepted" if params[:include_accepted] == '1'
    profile_types << "Withdrawn" if params[:include_withdrawn] == '1'
    profile_types << "StaffProfile" if params[:include_staff] == '1'

    conditions_text = "(type IN (?))"
    conditions_subs = [profile_types]

    if params[:include_with_codes] == '1' && params[:without_codes] == '1'
      # no extra conditions needed for both with and without codes
    elsif params[:include_with_codes] == '1'
      conditions_text << " AND (motivation_code IS NOT null AND motivation_code != '' AND motivation_code != '0')"
    elsif params[:include_without_codes] == '1'
      conditions_text << " AND (motivation_code IS null OR motivation_code = '' OR motivation_code = '0')"
    end

    @profiles = Profile.by_event_group(params[:event_group_id], conditions_text, conditions_subs).
      find(:all, :order => 'motivation_code ASC', :include => [ :project, { :viewer => :persons }])
    #@profiles = []
  end
  
  def accept_from_paper
    @project = Project.find params[:project_id]
    
    form = @eg.application_form
      @appln = Appln.create :form_id => form.id,
        :viewer_id => params[:viewer_id],
        :status => "started"
    
    @appln.save!
    @appln.accepted!
    
    as_intern = params[:as_intern] == '1' || params[:as_intern] == 'true'    
    acceptance = Acceptance.create :appln_id => @appln.id, :project_id => @project.id, 
      :support_claimed => 0, :support_coach_id => params[:support_coach_id], 
      :accepted_by_viewer_id => @viewer.id, :as_intern => as_intern,
      :viewer_id => @appln.viewer.id
     
    SpApplicationMailer.deliver_accepted(acceptance, @viewer.email)
    
    flash[:notice] = "#{@appln.viewer.name} accepted to #{@project.title}.  " + 
        "<a href='/appln/view_always_editable?appln_id=#{@appln.id}'>Edit their always editable fields.</a>"
    
    redirect_to :action => 'input_from_paper_index'
  end
  
  def input_from_paper_index
    @possible_viewers = Viewer.find(:all).collect{|v| 
      if v.is_student? then v else nil end
    }.compact
    
    @possible_viewers.sort!{ |a,b| a.name <=> b.name }
    
    if (@viewer.is_eventgroup_coordinator?(@eg))
      processor_for_project_ids = @eg.projects.find(:all).collect{ |p| p.id }
    else
      # find which projects @viewer is a processor for
      processor_for_project_ids = Processor.find_all_by_viewer_id(@viewer.id, :include => :project).collect { 
        |entry| if entry.project.event_group_id == @eg.id then entry.project_id else nil end }.compact
    end
    @possible_projects = @eg.projects.find processor_for_project_ids
    @possible_projects.sort!{ |a,b| a.title <=> b.title }
  end
  
  def get_reference_request_email
    @reference = ApplnReference.find params[:ref_id]
    @appln = Appln.find(@reference.instance_id)

    if @appln.viewer.nil?
      render :inline => "<P>Strangely, this reference seems to not be owned by anyone.  " + 
        "Please report this to #{$tech_email_only} and mention the reference id is " + params[:ref_id] + "</P>", :layout => true
      return
    end
    
    @subject = 'Summer Project Reference'
    @recipients = @reference.email
    @from = $sp_email
    @applicant_name = @appln.viewer.name
    @applicant_email = @appln.viewer.email
    @applicant_phone = @appln.viewer.phone
    @ref_first_name = @reference.first_name
    @ref_last_name = @reference.last_name
    @ref_url = @reference.ref_url
    
    render_from_email 'ref_request', @appln.form.event_group
  end
  
  def reference_resend_or_bypass
    @submitted_profiles = Profile.find_all_by_status 'submitted', :include => { :appln => :form }
    @submitted_apps = @submitted_profiles.collect(&:appln).flatten
    @submitted_apps.reject! { |app| app.form.event_group != @eg }
    @submitted_apps.sort! { |a,b| (a.viewer.nil? ? nil.to_s : a.viewer.name) <=> (b.viewer.nil? ? nil.to_s : b.viewer.name) }
  end
  
  def resend_reference_email
    @reference = ReferenceInstance.find_by_id(params[:ref_id])
    @reference.send_invitation

    flash[:notice] = "Reference request email resent to #{@reference.first_name} #{@reference.last_name} (#{@reference.email})."
    redirect_to :action => :index
  end

  protected
  
  def ensure_eventgroup_coordinator
    is = @viewer.is_eventgroup_coordinator?(@eg)
    render :inline => "Sorry, you don't have permission to view this page." if !is
    is
  end
  
  def set_title() @page_title = "Tools" end
  
  def render_from_email(type, event_group)
    header = "<BR>From: #{@from}<BR>\n" + 
             "To: #{@recipients}<BR>\n" + 
             "<BLOCKQUOTE>\n"
    footer = "</BLOCKQUOTE>"
    render :inline => header + event_group.reference_emails.find_by_email_type(type).text + footer, :layout => true
  end

  def get_manual_donations_from_criteria
    start_date = DateTime.new_from_hash params[:start]
    end_date = DateTime.new_from_hash params[:end]

    @usd = DonationType.find_by_description 'USDMANUAL'
    @manual_donations = ManualDonation.find :all, :conditions => [ %|
           donation_type_id = ? AND status = ? AND created_at > ? and created_at < ?
             |, @usd.id, params[:find_status], start_date, end_date ],
      :include => :donation_type_obj
  end
end

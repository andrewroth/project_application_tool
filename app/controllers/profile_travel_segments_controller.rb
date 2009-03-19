require_dependency 'permissions.rb'

class ProfileTravelSegmentsController < ApplicationController
  include Permissions
  include TravelSegmentTagsAutocomplete
  
  skip_before_filter :restrict_students, :only => [ :assigned ]
  before_filter :get_profile, :except => [ :auto_complete_for_travel_segment_tags ]
  before_filter :is_project_staff, :except => [ :assigned, :auto_complete_for_travel_segment_tags ]
  before_filter :ensure_profile_ownership_or_any_project_staff, :except => 
                                              [ :auto_complete_for_travel_segment_tags ]
  before_filter :get_travel_segment, :only => [ :new, :delete, :update_attribute_form, :edit, :update ]
  before_filter :get_profile_travel_segment, :only => [ :new, :delete, :update_attribute_form, :edit, :update ]
  before_filter :set_editors
  
  def index
    redirect_to :action => :list, :profile_id => params[:profile_id]
  end
  
  def set_editors
    want_full = !params[:restrict]
    if want_full && !@viewer.is_student?
      @editors = 'all_editors'
    else
      @editors = 'restricted'
    end
  end
  
  def update_attribute_form
    if %w(eticket confirmation_number).include?(params[:attribute])
      @editor = :text_field
    end
  end

  def list
    @pts = {}
    @assigned_ts = []
    @profile.profile_travel_segments.each do |pts|
      ts = pts.travel_segment
      next if ts.nil?

      @assigned_ts << ts;
      @pts[ts.id] = pts
    end

    @can_edit = is_project_staff && params[:print].nil? && !params[:restrict]
    @unassigned_ts = TravelSegment.current - @assigned_ts
    @unassigned_ts.sort!
  end
  
  def assigned
    list

    @page_title = "Itinerary for #{@viewer.name}"

    if params[:partial]
      render :partial => 'assigned_list', :locals => { :can_edit => true, :div => false }
    end
  end
  
  # creates a travel segment and assigns it to the current profile
  def create_and_assign
    params[:travel_segment] ||= { }
    begin
      @travel_segment = TravelSegment.new_with_parse params[:travel_segment]

      if @travel_segment.save
        @success = true
        @edit_id = @travel_segment.id
	new # this will assign the travel segment
      end

    rescue
      @error_msg = $!
      @ts_line = params[:travel_segment][:parse_line]
      @parse_error = true
    end
  end
  
  def reorder
    params[:assigned_tbody].each_with_index do |id, position|
      pts = @profile.profile_travel_segments.find_by_travel_segment_id(id)
      pts.position = position
      pts.save!
    end

    render :inline => 'success'
  end

  def add_shortcut
    @travel_segment = TravelSegment.new
    @pts = ProfileTravelSegment.new
  end
  
  # returns only the assigned travel segments list
  def new
    if @pts.nil?
      profile_segments = @profile.profile_travel_segments
      
      position = if profile_segments.empty?
          1
        else
          profile_segments[profile_segments.size-1].position + 1
        end
      create_params = params[:profile_travel_segment] || {}
      create_params.merge!( { :travel_segment => @travel_segment, :position => position } )
      @created = @profile.profile_travel_segments.create create_params
    end
    
    list

    unless request.xml_http_request?
      #render :inline => @assigned_ts.size
      #redirect_to :action => :list, :profile_id => @profile.id, :travel_segment_id => @travel_segment.id
    end
  end
  
  # returns the unassigned travel segments list
  def delete
    @pts.destroy
    @unassigned_travel_segment = @travel_segment
    
    list

    unless request.xml_http_request?
      redirect_to :action => :list, :profile_id => @profile.id, :travel_segment_id => @travel_segment.id
    end
  end
  
  def filter_travel_segments
    list
    
    @unassigned_ts = TravelSegment.filter(@unassigned_ts, params)
    
    render :partial => 'unassigned_list', :locals => { :sortable => true }
  end

# Filter used with form remote tag
#  
#  def filter_travel_segments
#    list
#    flight_num      = params[:travel_segments][:flight_num]
#    departure_date  = params[:travel_segments][:departure_date]
#   
#    @unassigned_ts.collect! { |ts| flight_num.nil? || flight_num == "" || 
#      ts.flight_no =~ /.*#{flight_num.strip}.*/i  ? ts : nil }
#    @unassigned_ts.compact!
#    
#    @unassigned_ts.collect! { |ts| 
#      if departure_date.nil? || departure_date == ""
#        ts
#      else
#        departure_date_array = departure_date.split()
#        if format_datetime(ts.departure_time,:ts) =~ 
#          /.*#{departure_date_array[0]}.*#{departure_date_array[1]}.*#{departure_date_array[2]}.*#{departure_date_array[3]}.*/i
#          ts
#        else
#          nil
#        end
#      end
#    }
#    @unassigned_ts.compact!
#      
#    render :partial => 'unassigned_list', :locals => { :sortable => true }
#  end
  
  def update
    if params[:travel_segment]
      @travel_segment.update_attributes params[:travel_segment]
      @travel_segment.save!
      #@travel_segment.rerequire   Not sure what this was for but it was
      # producing an error and it works fine without it
    end

    pts_atts = params[:pts] || params[:profile_travel_segment] || {}
    @pts.update_attributes pts_atts
    @pts.save!
    #@pts.rerequire Not sure what this was for but it was producing an 
    #error and it works fine without it

    if params[:return] == 'assigned'
      params[:partial] = true
      assigned
    else
      render :inline => @pts.send(params[:return]).to_s
    end
  end

  protected
    def get_profile
      @profile = Profile.find params[:profile_id]
    end
    
    def get_travel_segment
      @travel_segment = TravelSegment.find(params[:travel_segment_id])
    end
    
    def get_profile_travel_segment
      @pts = ProfileTravelSegment.find_by_profile_id_and_travel_segment_id @profile.id, 
      @travel_segment.id
    end

    def is_project_staff
      return @viewer.is_eventgroup_coordinator? ||
          @viewer.is_atleast_project_staff(@profile.project)
    end
end

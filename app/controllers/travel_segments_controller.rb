class TravelSegmentsController < ApplicationController
  include TravelSegmentTagsAutocomplete
  
  before_filter :set_menu_titles
  before_filter :get_travel_segment, :only => [ :update, :show, :destroy, :edit, :edit_in_row ]
  before_filter :ensure_atleast_project_staff, :except => [ :test_parse ]

  skip_before_filter :verify_event_group_chosen, :only => [ :test_parse ]
  skip_before_filter :verify_user, :only => [ :test_parse ]
  skip_before_filter :set_event_group, :only => [ :test_parse ]
  
  TravelSegment.all_editors.each_pair do |k,v|
    in_place_edit_for(:travel_segment, k) if v == :inplace_editor
  end
  
  def test_parse
    if request.xml_http_request?
      @ts = TravelSegment.parse(params[:ts_line], :demo => true)
      render :partial => 'show'
      return
    end
    
    render :layout => false
  end

  def index
    list
    render :action => 'list', :layout => true
  end
  
  def filter_travel_segments
    list (params[:include_old] == 'true' ? :all : :current)

    @travel_segments = TravelSegment.filter(@travel_segments, params)
    render :partial => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  def list(initial_find = :current)
    # Russ wants us to use *all* travel segments, not for a given event_group
    #  see http://ccc.clockingit.com/tasks/edit/35811
    @travel_segments ||= if initial_find == :current then 
         TravelSegment.current 
       elsif initial_find == :all then
         TravelSegment.find(:all)
       end

    @travel_segments.sort! { |a,b| 
      a_dt_nil = a.departure_time.nil?
      b_dt_nil = b.departure_time.nil?
      if a_dt_nil && b_dt_nil
        0
      elsif a_dt_nil && !b_dt_nil
        1
      elsif !a_dt_nil && b_dt_nil
        -1
      else
        b.departure_time <=> a.departure_time
      end
    }
    @just_modified_id = @travel_segment.id if @travel_segment
    @just_modified_id ||= flash[:just_modified_id]
  end
  
  def edit_in_row
    render :partial => 'edit_in_row'
  end
  
  def edit
    @just_modified = false
  end
  
  def new
    @travel_segment = TravelSegment.new
  end
  
  def create
    params[:travel_segment] ||= { }
    params[:travel_segment][:event_group_id] = @eg.id
    @travel_segment = TravelSegment.new_with_parse params[:travel_segment]
    @travel_segment.event_group_id = @eg.id
    
    if @travel_segment.save
      @edit_id = @travel_segment.id if !(params[:skip_editing] == 'true')
      flash[:notice] = 'TravelSegment was successfully created.'
      list
    else
      render :action => 'new'
    end
  end

  def update
    if @travel_segment.update_attributes(params[:travel_segment])
      list
      render :partial => 'list', :layout => !request.xml_http_request?
    else
      render :action => 'edit'
    end
  end

  def destroy
    @travel_segment.destroy
    list
    render :action => '_list'
  end

    protected

    def set_menu_titles() @page_title = 'Manage Projects'; @submenu_title = 'travel segments' end
    
    def ensure_atleast_project_staff
      return @viewer.is_eventgroup_coordinator?(@eg) || @viewer.is_any_project_staff(@eg)
    end
    
    def get_travel_segment
      @travel_segment = TravelSegment.find(params[:id])
    end
end
